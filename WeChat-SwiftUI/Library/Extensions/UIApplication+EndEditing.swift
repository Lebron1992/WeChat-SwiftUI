import UIKit

extension UIApplication {
  var keyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .compactMap({ $0 as? UIWindowScene })
      .first?.windows
      .filter({ $0.isKeyWindow }).first
  }

  func endEditing(_ force: Bool) {
    keyWindow?.endEditing(force)
  }
}
