import SwiftUI

extension Color {
  static var bg_info_100: Color {
    .init("bg_info_100")
  }

  static var bg_info_200: Color {
    .init("bg_info_200")
  }

  static var highlighted: Color {
    .init("highlighted")
  }

  static var text_primary: Color {
    .init("text_primary")
  }
}

extension UIColor {
  static var bg_info_200: UIColor {
    .init(named: "bg_info_200")!
  }

  static var text_primary: UIColor {
    .init(named: "text_primary")!
  }
}
