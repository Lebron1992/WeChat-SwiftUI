import Foundation

protocol NSBundleType {
  static func create(path: String) -> NSBundleType?
  func path(forResource name: String?, ofType ext: String?) -> String?
  func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
}

extension Bundle: NSBundleType {
  static func create(path: String) -> NSBundleType? {
    return Bundle(path: path)
  }
}
