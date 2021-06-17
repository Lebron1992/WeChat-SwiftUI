import Foundation

func tryDecode<T: Decodable>(_ primitive: Any) -> T? {
  guard
    let data = try? JSONSerialization.data(withJSONObject: primitive, options: []),
    let value = try? JSONDecoder().decode(T.self, from: data)
  else { return nil }

  return value
}

func tryDecode<T: Decodable>(_ jsonString: String) -> T? {
  guard
    let data = jsonString.data(using: .utf8),
    let value = try? JSONDecoder().decode(T.self, from: data)
  else { return nil }

  return value
}
