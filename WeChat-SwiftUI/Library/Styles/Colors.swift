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

  static var bg_info_170: Color {
    .init("bg_info_170")
  }

  static var bg_info_200: Color {
    .init("bg_info_200")
  }

  static var bg_info_300: Color {
    .init("bg_info_300")
  }

  static var bg_text_input: Color {
    .init("bg_text_input")
  }

  static var bg_expression_preview: Color {
    .init("bg_expression_preview")
  }

  static var bg_chat_incoming_msg: Color {
    .init("bg_chat_incoming_msg")
  }

  static var bg_chat_outgoing_msg: Color {
    .init("bg_chat_outgoing_msg")
  }

  static var text_primary: Color {
    .init("text_primary")
  }

  static var text_info_50: Color {
    .init("text_info_50")
  }

  static var text_info_80: Color {
    .init("text_info_80")
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

  static var text_expression_preview: Color {
    .init("text_expression_preview")
  }

  static var text_chat_incoming_msg: Color {
    .init("text_chat_incoming_msg")
  }

  static var text_chat_outgoing_msg: Color {
    .init("text_chat_outgoing_msg")
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

extension ShapeStyle where Self == Color {

  static var highlighted: Color {
    .highlighted
  }

  static var app_white: Color {
    .app_white
  }

  static var app_bg: Color {
    .app_bg
  }

  static var bg_info_100: Color {
    .bg_info_100
  }

  static var bg_info_150: Color {
    .bg_info_150
  }

  static var bg_info_170: Color {
    .bg_info_170
  }

  static var bg_info_200: Color {
    .bg_info_200
  }

  static var bg_info_300: Color {
    .bg_info_300
  }

  static var bg_text_input: Color {
    .bg_text_input
  }

  static var bg_expression_preview: Color {
    .bg_expression_preview
  }

  static var bg_chat_incoming_msg: Color {
    .bg_chat_incoming_msg
  }

  static var bg_chat_outgoing_msg: Color {
    .bg_chat_outgoing_msg
  }
}
