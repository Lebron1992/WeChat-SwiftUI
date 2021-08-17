import Combine
import Foundation
import Kickstarter_Prelude

/// 用于执行数据请求的类型
protocol ServiceType {
  var serverConfig: ServerConfigType { get }
  var oauthToken: OauthTokenAuthType? { get }

  init(
    serverConfig: ServerConfigType,
    oauthToken: OauthTokenAuthType?
  )

  /// 返回替换了 oauthToken 的 service。
  func login(_ oauthToken: OauthTokenAuthType) -> Self

  /// 返回把 oauthToken 设置为 nil 的 service。
  func logout() -> Self

  /// 获取联系人
  func loadContacts() -> AnyPublisher<[User], Error>

  /// 获取公众号
  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error>

  /// 获取自己的信息
  func loadUserSelf() -> AnyPublisher<User, Error>
}

func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
  type(of: lhs) == type(of: rhs) &&
    lhs.serverConfig == rhs.serverConfig &&
    lhs.oauthToken == rhs.oauthToken
}

func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
  !(lhs == rhs)
}

extension ServiceType {

  /// 准备要发送到服务器的URL请求。
  /// - Parameters:
  ///   - originalRequest: 需要准备的请求。
  ///   - query: 附加到请求的其他查询参数。
  /// - Returns: 为服务器正确配置的新URL请求。
  func preparedRequest(
    forRequest originalRequest: URLRequest,
    query: [String: Any] = [:]
  ) -> URLRequest {

    var request = originalRequest
    guard let URL = request.url else {
      return originalRequest
    }

    var headers = defaultHeaders

    let method = request.httpMethod?.uppercased()
    var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    var queryItems = components.queryItems ?? []

    if method == .some("POST") || method == .some("PUT") {
      if request.httpBody == nil {
        headers["Content-Type"] = "application/json; charset=utf-8"
        request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
      }
    } else {
      queryItems.append(
        contentsOf: query
          .flatMap(queryComponents)
          .map(URLQueryItem.init(name:value:))
      )
    }
    components.queryItems = queryItems.sorted { $0.name < $1.name }
    request.url = components.url

    let currentHeaders = request.allHTTPHeaderFields ?? [:]
    request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(headers)

    return request
  }

  /// 准备要发送到服务器的请求。
  /// - Parameters:
  ///   - url: 要转换为请求的URL。
  ///   - method: 用于请求的请求方法
  ///   - query: 附加到请求的其他查询参数。
  /// - Returns: 为服务器正确配置的新URL请求。
  func preparedRequest(
    forURL url: URL,
    method: Method = .GET,
    query: [String: Any] = [:]
  ) -> URLRequest {

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return preparedRequest(forRequest: request, query: query)
  }

  private var defaultHeaders: [String: String] {
    guard let authorizationHeader = authorizationHeader else {
      return [:]
    }
    return ["Authorization": authorizationHeader]
  }

  private var authorizationHeader: String? {
    if let token = self.oauthToken?.token {
      return "token \(token)"
    }
    return nil
  }

  private func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
    var components: [(String, String)] = []

    if let dictionary = value as? [String: Any] {
      for (nestedKey, value) in dictionary {
        components += self.queryComponents("\(key)[\(nestedKey)]", value)
      }
    } else if let array = value as? [Any] {
      for value in array {
        components += self.queryComponents("\(key)[]", value)
      }
    } else {
      components.append((key, String(describing: value)))
    }

    return components
  }
}
