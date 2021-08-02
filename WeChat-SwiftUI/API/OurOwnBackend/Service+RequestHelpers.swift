import Combine
import Foundation

extension Service {
  private static let session = URLSession(configuration: .default)

  func request<M: Decodable>(_ route: Route) -> AnyPublisher<M, Error> {
    let properties = route.requestProperties

    guard let url = URL(string: "\(serverConfig.apiBaseUrl.absoluteString)\(properties.path)") else {
      let error = APIError.invalidURL(serverConfig.apiBaseUrl.absoluteString + properties.path)
      return Fail<M, Error>(error: error).eraseToAnyPublisher()
    }
    print("\(url): \(properties.method) \(properties.query)")

    let request = preparedRequest(forURL: url, method: properties.method, query: properties.query)
    return Service.session
      .dataTaskPublisher(for: request)
      .requestJSON()
  }
}
