import UIKit

extension UIApplication {
  func endEditing(_ force: Bool) {
    windows.filter { $0.isKeyWindow }.first?.endEditing(force)
  }
}
