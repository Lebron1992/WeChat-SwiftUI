import Foundation

enum APIError: Error {
  case internalServerError
  case invalidURL(String)
  case unexpectedResponse(HTTPURLResponse)
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .internalServerError:
      return "内部服务器错误"
    case let .invalidURL(url):
      return "无效的 URL: \(url)"
    case let .unexpectedResponse(response):
      return "出乎意料的响应: \(response)"
    }
  }
}
