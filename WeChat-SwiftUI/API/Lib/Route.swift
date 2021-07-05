/// 数据请求的列表
enum Route {
  case loadContacts
  case loadOfficialAccounts
  case loadUserSelf

  var requestProperties:
    (method: Method, path: String, query: [String: Any]) {
    switch self {
    case .loadContacts:
      return (.GET, "/users/contacts.json", [:])

    case .loadOfficialAccounts:
      return (.GET, "/official_accounts/accounts.json", [:])

    case .loadUserSelf:
      return (.GET, "/users/me.json", [:])
    }
  }
}
