import Combine

struct FirestoreServiceMock: FirestoreServiceType {

  let loadContactsResponse: [User]?
  let loadContactsError: Error?

  let loadOfficialAccountsResponse: [OfficialAccount]?
  let loadOfficialAccountsError: Error?

  let loadUserSelfResponse: User?
  let loadUserSelfError: Error?

  let overrideUserError: Error?

  init(
    loadContactsResponse: [User]? = nil,
    loadContactsError: Error? = nil,
    loadOfficialAccountsResponse: [OfficialAccount]? = nil,
    loadOfficialAccountsError: Error? = nil,
    loadUserSelfResponse: User? = nil,
    loadUserSelfError: Error? = nil,
    overrideUserError: Error? = nil
  ) {
    self.loadContactsResponse = loadContactsResponse
    self.loadContactsError = loadContactsError

    self.loadOfficialAccountsResponse = loadOfficialAccountsResponse
    self.loadOfficialAccountsError = loadOfficialAccountsError

    self.loadUserSelfResponse = loadUserSelfResponse
    self.loadUserSelfError = loadUserSelfError

    self.overrideUserError = overrideUserError
  }

  func loadContacts() -> AnyPublisher<[User], Error> {
    if let error = loadContactsError {
      return .publisher(failure: error)
    }
    return .publisher(output: loadContactsResponse ?? [.template, .template2])
  }

  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error> {
    if let error = loadOfficialAccountsError {
      return .publisher(failure: error)
    }
    return .publisher(output: loadOfficialAccountsResponse ?? [.template, .template2])
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
