/// 数据请求的列表
enum Route {
  case route

  var requestProperties:
    (method: Method, path: String, query: [String: Any]) {
    switch self {
    case .route:
      return (.GET, "/v1/route", [:])
    }
  }
}
