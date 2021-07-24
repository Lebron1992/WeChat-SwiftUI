/// 提供 oauth token 身份验证的类型。
protocol OauthTokenAuthType {
  var token: String { get }
}

func == (lhs: OauthTokenAuthType, rhs: OauthTokenAuthType) -> Bool {
  type(of: lhs) == type(of: rhs) &&
    lhs.token == rhs.token
}

func == (lhs: OauthTokenAuthType?, rhs: OauthTokenAuthType?) -> Bool {
  type(of: lhs) == type(of: rhs) &&
    lhs?.token == rhs?.token
}

struct OauthToken: OauthTokenAuthType {
  let token: String

  init(token: String) {
    self.token = token
  }
}
