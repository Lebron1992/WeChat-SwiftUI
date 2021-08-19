import Combine
import Foundation

extension AnyPublisher {
  func sinkForUI(
    receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void = { _ in },
    receiveValue: @escaping (Output) -> Void = { _ in }
  ) -> AnyCancellable {
    receive(on: DispatchQueue.main)
      .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
  }
}
