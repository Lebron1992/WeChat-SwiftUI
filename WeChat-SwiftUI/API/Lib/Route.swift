/// 数据请求的列表
enum Route {
  case loadContacts

  var requestProperties:
    (method: Method, path: String, query: [String: Any]) {
    switch self {
    case .loadContacts:
      return (.GET, "/users/contacts.json", [:])
    }
  }
}
