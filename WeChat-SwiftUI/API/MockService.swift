import Combine
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

  func loadContacts() -> AnyPublisher<[User], Error> {
    publisher(data: [User.template])
  }
}

extension MockService {
  private func publisher<T>(data: T) -> AnyPublisher<T, Error> {
    Just<Void>
      .withErrorType(Error.self)
      .map { data }
      .eraseToAnyPublisher()
  }
}
