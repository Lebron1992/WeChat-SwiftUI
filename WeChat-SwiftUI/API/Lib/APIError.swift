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
      return Strings.api_error_internal_server_error()
    case let .invalidURL(url):
      return Strings.api_error_invalid_url(url: url)
    case let .unexpectedResponse(response):
      return Strings.api_error_unexpected_response(response: "\(response)")
    }
  }
}
