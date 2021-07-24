import Combine

struct FirestoreServiceMock: FirestoreServiceType {
  func overrideUser(_ user: User) -> AnyPublisher<Void, Error> {
    publisher(data: ())
  }
}

extension FirestoreServiceMock {
  private func publisher<T>(data: T) -> AnyPublisher<T, Error> {
    Just<Void>
      .withErrorType(Error.self)
      .map { data }
      .eraseToAnyPublisher()
  }

  private func publisher<T>(error: Error) -> AnyPublisher<T, Error> {
    Fail<T, Error>(error: error)
      .eraseToAnyPublisher()
  }
}
