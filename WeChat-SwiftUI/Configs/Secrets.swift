enum Secrets {
  static let isMockService = false

  enum Api {
    enum Endpoint {
      static let production = "http://api.wechat.com"
      static let staging = "http://api-staging.wechat.com"
    }
  }
}
