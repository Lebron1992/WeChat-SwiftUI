import Combine
import Foundation

extension Publisher {

  func sinkToLoadableForUI(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
    receive(on: DispatchQueue.main)
      .sink(
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

  func sinkToValueForUI(completion: @escaping (Output) -> Void = { _ in }) -> AnyCancellable {
    sinkForUI(receiveValue: { completion($0) })
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
