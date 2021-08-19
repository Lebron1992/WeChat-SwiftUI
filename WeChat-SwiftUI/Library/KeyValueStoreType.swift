import Foundation

// MARK: - KeyValueStoreType
protocol KeyValueStoreType: AnyObject {
  func set(_ value: Bool, forKey key: KeyValueStoreKey)
  func set(_ value: Int, forKey key: KeyValueStoreKey)
  func set(_ value: Any?, forKey key: KeyValueStoreKey)

  func bool(forKey key: KeyValueStoreKey) -> Bool
  func data(forKey key: KeyValueStoreKey) -> Data?
  func dictionary(forKey key: KeyValueStoreKey) -> [String: Any]?
  func integer(forKey key: KeyValueStoreKey) -> Int
  func object(forKey key: KeyValueStoreKey) -> Any?
  func string(forKey key: KeyValueStoreKey) -> String?

  @discardableResult
  func synchronize() -> Bool

  func removeObject(forKey key: KeyValueStoreKey)
}

// MARK: - UserDefaults
extension UserDefaults: KeyValueStoreType {
  func set(_ value: Bool, forKey key: KeyValueStoreKey) {
    set(value, forKey: key.key)
  }

  func set(_ value: Int, forKey key: KeyValueStoreKey) {
    set(value, forKey: key.key)
  }

  func set(_ value: Any?, forKey key: KeyValueStoreKey) {
    set(value, forKey: key.key)
  }

  func bool(forKey key: KeyValueStoreKey) -> Bool {
    bool(forKey: key.key)
  }

  func data(forKey key: KeyValueStoreKey) -> Data? {
    data(forKey: key.key)
  }

  func dictionary(forKey key: KeyValueStoreKey) -> [String : Any]? {
    dictionary(forKey: key.key)
  }

  func integer(forKey key: KeyValueStoreKey) -> Int {
    integer(forKey: key.key)
  }

  func object(forKey key: KeyValueStoreKey) -> Any? {
    object(forKey: key.key)
  }

  func string(forKey key: KeyValueStoreKey) -> String? {
    string(forKey: key.key)
  }

  func removeObject(forKey key: KeyValueStoreKey) {
    set(nil, forKey: key)
  }
}

// MARK: - MockKeyValueStore
final class MockKeyValueStore: KeyValueStoreType {
  var store: [String: Any] = [:]

  func set(_ value: Bool, forKey key: KeyValueStoreKey) {
    store[key.key] = value
  }

  func set(_ value: Int, forKey key: KeyValueStoreKey) {
    store[key.key] = value
  }

  func set(_ value: Any?, forKey key: KeyValueStoreKey) {
    store[key.key] = value
  }

  func bool(forKey key: KeyValueStoreKey) -> Bool {
    store[key.key] as? Bool ?? false
  }

  func data(forKey key: KeyValueStoreKey) -> Data? {
    store[key.key] as? Data
  }

  func dictionary(forKey key: KeyValueStoreKey) -> [String: Any]? {
    object(forKey: key) as? [String: Any]
  }

  func integer(forKey key: KeyValueStoreKey) -> Int {
    store[key.key] as? Int ?? 0
  }

  func object(forKey key: KeyValueStoreKey) -> Any? {
    store[key.key]
  }

  func string(forKey key: KeyValueStoreKey) -> String? {
    store[key.key] as? String
  }

  func removeObject(forKey key: KeyValueStoreKey) {
    set(nil, forKey: key)
  }

  func synchronize() -> Bool {
    true
  }
}
