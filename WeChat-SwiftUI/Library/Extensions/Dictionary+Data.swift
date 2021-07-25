import Foundation

extension Dictionary {
  var data: Data? {
    try? JSONSerialization.data(withJSONObject: self)
  }
}
