import Combine

struct FirestoreServiceMock: FirestoreServiceType {

  let loadUserSelfResponse: User?
  let loadUserSelfError: Error?

  let overrideUserError: Error?

  init(
    loadUserSelfResponse: User? = nil,
    loadUserSelfError: Error? = nil,
    overrideUserError: Error? = nil
  ) {
    self.loadUserSelfResponse = loadUserSelfResponse
    self.loadUserSelfError = loadUserSelfError

    self.overrideUserError = overrideUserError
  }

  func loadUserSelf() -> AnyPublisher<User, Error> {
    if let error = loadUserSelfError {
      return .publisher(failure: error)
    }
    return .publisher(output: loadUserSelfResponse ?? .template)
  }

  func overrideUser(_ user: User) -> AnyPublisher<Void, Error> {
    if let error = overrideUserError {
      return .publisher(failure: error)
    }
    return .publisher(output: ())
  }
}
