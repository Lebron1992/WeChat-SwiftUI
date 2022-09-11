import Combine
import Foundation

struct MockService: ServiceType {

  let serverConfig: ServerConfigType
  let oauthToken: OauthTokenAuthType?

  let loadContactsResponse: [User]?
  let loadContactsError: Error?

  let loadOfficialAccountsResponse: [OfficialAccount]?
  let loadOfficialAccountsError: Error?

  let loadUserSelfResponse: User?
  let loadUserSelfError: Error?

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
    loadOfficialAccountsError: Error? = nil,
    loadUserSelfResponse: User? = nil,
    loadUserSelfError: Error? = nil
  ) {
    self.serverConfig = serverConfig
    self.oauthToken = oauthToken

    self.loadContactsResponse = loadContactsResponse
    self.loadContactsError = loadContactsError

    self.loadOfficialAccountsResponse = loadOfficialAccountsResponse
    self.loadOfficialAccountsError = loadOfficialAccountsError

    self.loadUserSelfResponse = loadUserSelfResponse
    self.loadUserSelfError = loadUserSelfError
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
      return .publisher(failure: error)
    }
    return .publisher(output: loadContactsResponse ?? [User.template1])
  }

  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error> {
    if let error = loadOfficialAccountsError {
      return .publisher(failure: error)
    }
    return .publisher(output: loadOfficialAccountsResponse ?? [OfficialAccount.template1])
  }

  func loadUserSelf() -> AnyPublisher<User, Error> {
    if let error = loadUserSelfError {
      return .publisher(failure: error)
    }
    return .publisher(output: loadUserSelfResponse ?? User.template1)
  }
}
