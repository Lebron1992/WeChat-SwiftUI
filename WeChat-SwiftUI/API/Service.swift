import Combine
import Foundation

struct Service: ServiceType {
  let serverConfig: ServerConfigType
  let oauthToken: OauthTokenAuthType?

  init(
    serverConfig: ServerConfigType = ServerConfig.production,
    oauthToken: OauthTokenAuthType? = nil
  ) {
    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
  }

  func login(_ oauthToken: OauthTokenAuthType) -> Service {
    Service(
      serverConfig: self.serverConfig,
      oauthToken: oauthToken
    )
  }

  func logout() -> Service {
    Service(
      serverConfig: self.serverConfig,
      oauthToken: nil
    )
  }

  func loadContacts() -> AnyPublisher<[User], Error> {
    request(.loadContacts)
  }
}
