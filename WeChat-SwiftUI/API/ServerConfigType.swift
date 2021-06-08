import Foundation

/// 保存网络服务器和 API 的位置的类型
protocol ServerConfigType {
  var apiBaseUrl: URL { get }
  var environment: EnvironmentType { get }
}

func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
  type(of: lhs) == type(of: rhs) &&
    lhs.apiBaseUrl == rhs.apiBaseUrl &&
    lhs.environment == rhs.environment
}

struct ServerConfig: ServerConfigType {
  let apiBaseUrl: URL
  let environment: EnvironmentType

  static let production: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: Secrets.Api.Endpoint.production)!,
    environment: .production
  )

  static let staging: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: Secrets.Api.Endpoint.staging)!,
    environment: .staging
  )

  init(
    apiBaseUrl: URL,
    environment: EnvironmentType = .production
  ) {
    self.apiBaseUrl = apiBaseUrl
    self.environment = environment
  }
}
