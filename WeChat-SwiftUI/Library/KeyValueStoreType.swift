import Foundation

protocol KeyValueStoreType: AnyObject {
  func set(_ value: Bool, forKey defaultName: String)
  func set(_ value: Int, forKey defaultName: String)
  func set(_ value: Any?, forKey defaultName: String)

  func bool(forKey defaultName: String) -> Bool
  func data(forKey defaultName: String) -> Data?
  func dictionary(forKey defaultName: String) -> [String: Any]?
  func integer(forKey defaultName: String) -> Int
  func object(forKey defaultName: String) -> Any?
  func string(forKey defaultName: String) -> String?
  func synchronize() -> Bool

  func removeObject(forKey defaultName: String)
}

extension UserDefaults: KeyValueStoreType {}

class MockKeyValueStore: KeyValueStoreType {
  var store: [String: Any] = [:]

  func set(_ value: Bool, forKey defaultName: String) {
    store[defaultName] = value
  }

  func set(_ value: Int, forKey defaultName: String) {
    store[defaultName] = value
  }

  func set(_ value: Any?, forKey key: String) {
    store[key] = value
  }

  func bool(forKey defaultName: String) -> Bool {
    store[defaultName] as? Bool ?? false
  }

  func data(forKey defaultName: String) -> Data? {
    store[defaultName] as? Data
  }

  func dictionary(forKey key: String) -> [String: Any]? {
    object(forKey: key) as? [String: Any]
  }

  func integer(forKey defaultName: String) -> Int {
    store[defaultName] as? Int ?? 0
  }

  func object(forKey key: String) -> Any? {
    store[key]
  }

  func string(forKey defaultName: String) -> String? {
    store[defaultName] as? String
  }

  func removeObject(forKey defaultName: String) {
    set(nil, forKey: defaultName)
  }

  func synchronize() -> Bool {
    true
  }
}
