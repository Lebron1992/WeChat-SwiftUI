enum Secrets {
  static let isMockService = false

  enum Api {
    enum Endpoint {
      static let production = "https://api.wechat.com"
      static let staging = "https://api-staging.wechat.com"
    }
  }
}
