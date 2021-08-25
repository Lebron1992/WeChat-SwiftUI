import Combine
import Foundation

extension Publisher {

  func sinkToLoadableForUI(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
    sinkForUI(
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

  func sinkToResultForUI(completion: @escaping (Result<Output, Error>) -> Void = { _ in }) -> AnyCancellable {
    sinkForUI(
        receiveCompletion: { subscriptionCompletion in
          if let error = subscriptionCompletion.error {
            completion(.failure(error))
          }
        },
        receiveValue: { value in
          completion(.success(value))
        }
      )
  }

  func sinkForUI(
    receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void = { _ in },
    receiveValue: @escaping (Output) -> Void = { _ in }
  ) -> AnyCancellable {
    receive(on: DispatchQueue.main)
      .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
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
