import Foundation

enum KeyValueStoreKey: String {
  case appEnvironment
  case appState

  var key: String {
    "com.WeChat-SwiftUI.\(rawValue)"
  }
}
