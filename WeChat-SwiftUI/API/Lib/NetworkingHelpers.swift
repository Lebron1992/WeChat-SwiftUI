import Combine
import Foundation

extension Publisher where Output == URLSession.DataTaskPublisher.Output {

  /// 把响应的 data 解析成指定的数据模型
  /// - Returns: 携带有指定数据模型的 AnyPublisher
  func requestJSON<M: Decodable>() -> AnyPublisher<M, Error> {

    tryMap { input -> JSONDecoder.Input in
      assert(!Thread.isMainThread)

      Swift.print("json response: \(String(data: input.data, encoding: .utf8) ?? "")")

      guard let response = input.1 as? HTTPURLResponse else {
        fatalError()
      }

      guard (200..<300).contains(response.statusCode) else {
        if response.statusCode == 500 {
          throw APIError.internalServerError
        }
        throw APIError.unexpectedResponse(response)
      }

      return input.data
    }
    .extractUnderlyingError()
    .decode(type: M.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }
}

extension Just where Output == Void {
  static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
    withErrorType((), E.self)
  }
}

extension Just {
  static func withErrorType<E>(_ value: Output, _ errorType: E.Type) -> AnyPublisher<Output, E> {
    Just(value)
      .setFailureType(to: E.self)
      .eraseToAnyPublisher()
  }
}

extension Publisher {
  func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
    mapError {
      ($0.underlyingError as? Failure) ?? $0
    }
  }

  func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
    sink(
      receiveCompletion: { subscriptionCompletion in
        if let error = subscriptionCompletion.error {
          completion(.failed(error))
        }
      },
      receiveValue: { value in
        completion(.loaded(value))
      }
    )
  }
}

private extension Error {
  var underlyingError: Error? {
    let nsError = self as NSError
    if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
      // "Internet连接处于离线状态。"
      return self
    }
    return nsError.userInfo[NSUnderlyingErrorKey] as? Error
  }
}

private extension Subscribers.Completion {
  var error: Failure? {
    switch self {
    case let .failure(error): return error
    default: return nil
    }
  }
}
