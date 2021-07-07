import SwiftUI

extension Color {

  static var app_white: Color {
    .init("app_white")
  }

  static var app_bg: Color {
    .init("app_bg")
  }

  static var link: Color {
    .init("link")
  }

  static var highlighted: Color {
    .init("highlighted")
  }

  static var bg_info_100: Color {
    .init("bg_info_100")
  }

  static var bg_info_150: Color {
    .init("bg_info_150")
  }

  static var bg_info_200: Color {
    .init("bg_info_200")
  }

  static var bg_info_300: Color {
    .init("bg_info_300")
  }

  static var text_primary: Color {
    .init("text_primary")
  }

  static var text_info_100: Color {
    .init("text_info_100")
  }

  static var text_info_200: Color {
    .init("text_info_200")
  }

  static var text_info_500: Color {
    .init("text_info_500")
  }

  static var text_input_bg: Color {
    .init("text_input_bg")
  }
}

extension UIColor {
  static var app_bg: UIColor {
    .init(named: "app_bg")!
  }

  static var text_primary: UIColor {
    .init(named: "text_primary")!
  }
}
