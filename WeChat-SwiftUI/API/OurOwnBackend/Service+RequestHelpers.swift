import Combine
import Foundation

extension Service {
  private static let session = URLSession(configuration: .default)

  func request<M: Decodable>(_ route: Route) -> AnyPublisher<M, Error> {
    let properties = route.requestProperties
    let urlString = serverConfig.apiBaseUrl.absoluteString + properties.path

    guard let url = URL(string: urlString) else {
      return Fail<M, Error>(error: APIError.invalidURL(urlString))
        .eraseToAnyPublisher()
    }

    print("\(url): \(properties.method) \(properties.query)")

    let request = preparedRequest(forURL: url, method: properties.method, query: properties.query)
    return Service.session
      .dataTaskPublisher(for: request)
      .requestJSON()
  }
}
