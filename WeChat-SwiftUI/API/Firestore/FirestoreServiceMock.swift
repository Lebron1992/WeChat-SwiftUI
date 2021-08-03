import Combine

struct FirestoreServiceMock: FirestoreServiceType {

  let loadUserSelfResponse: User?
  let loadUserSelfError: Error?

  init(
    loadUserSelfResponse: User? = nil,
    loadUserSelfError: Error? = nil
  ) {
    self.loadUserSelfResponse = loadUserSelfResponse
    self.loadUserSelfError = loadUserSelfError
  }

  func loadUserSelf() -> AnyPublisher<User, Error> {
    if let error = loadUserSelfError {
      return publisher(error: error)
    }
    return publisher(data: loadUserSelfResponse ?? .template)
  }

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
