import Combine
import Foundation

extension AnyPublisher {
  static func publisher<T>(output: T) -> AnyPublisher<T, Error> {
    Just<Void>
      .withErrorType(Error.self)
      .map { output }
      .eraseToAnyPublisher()
  }

  static func publisher<T>(failure: Error) -> AnyPublisher<T, Error> {
    Fail<T, Error>(error: failure)
      .eraseToAnyPublisher()
  }
}
