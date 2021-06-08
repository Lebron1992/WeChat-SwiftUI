import Foundation

struct MockService: ServiceType {
  let serverConfig: ServerConfigType
  let oauthToken: OauthTokenAuthType?

  init(
    serverConfig: ServerConfigType,
    oauthToken: OauthTokenAuthType?
  ) {
    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
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
}
