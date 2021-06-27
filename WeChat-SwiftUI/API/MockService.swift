import Combine
import Foundation

struct MockService: ServiceType {
  let serverConfig: ServerConfigType
  let oauthToken: OauthTokenAuthType?

  let loadContactsResponse: [User]?
  let loadContactsError: Error?

  let loadOfficialAccountsResponse: [OfficialAccount]?
  let loadOfficialAccountsError: Error?

  init(
    serverConfig: ServerConfigType,
    oauthToken: OauthTokenAuthType?
  ) {
    self.init(
      serverConfig: serverConfig,
      oauthToken: oauthToken,
      loadContactsResponse: nil
    )
  }

  init(
    serverConfig: ServerConfigType = ServerConfig.production,
    oauthToken: OauthTokenAuthType? = nil,
    loadContactsResponse: [User]? = nil,
    loadContactsError: Error? = nil,
    loadOfficialAccountsResponse: [OfficialAccount]? = nil,
    loadOfficialAccountsError: Error? = nil
  ) {
    self.serverConfig = serverConfig
    self.oauthToken = oauthToken

    self.loadContactsResponse = loadContactsResponse
    self.loadContactsError = loadContactsError

    self.loadOfficialAccountsResponse = loadOfficialAccountsResponse
    self.loadOfficialAccountsError = loadOfficialAccountsError
  }

  func login(_ oauthToken: OauthTokenAuthType) -> MockService {
    MockService(
      serverConfig: self.serverConfig,
      oauthToken: oauthToken
    )
  }

  func logout() -> MockService {
    MockService(
      serverConfig: self.serverConfig,
      oauthToken: nil
    )
  }

  func loadContacts() -> AnyPublisher<[User], Error> {
    if let error = loadContactsError {
      return publisher(error: error)
    }
    return publisher(data: loadContactsResponse ?? [User.template])
  }

  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error> {
    if let error = loadOfficialAccountsError {
      return publisher(error: error)
    }
    return publisher(data: loadOfficialAccountsResponse ?? [OfficialAccount.template])
  }
}

extension MockService {
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
