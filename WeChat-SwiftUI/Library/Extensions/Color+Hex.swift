import SwiftUI

extension Color {

  static func hex(_ value: UInt32) -> Color {
    let r = Double((value & 0xFF0000) >> 16) / 255.0
    let g = Double((value & 0xFF00) >> 8) / 255.0
    let b = Double(value & 0xFF) / 255.0

    return Color(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
  }

  static func hex(_ value: String) -> Color? {

    let start = value.starts(with: "#") ?
      value.index(value.startIndex, offsetBy: 1) : value.startIndex
    let hexColor = String(value[start...])

    let r, g, b: Double
    let scanner = Scanner(string: hexColor)
    var hexNumber: UInt64 = 0

    if scanner.scanHexInt64(&hexNumber) {
      r = Double((hexNumber & 0xFF0000) >> 16) / 255
      g = Double((hexNumber & 0xFF00) >> 8) / 255
      b = Double((hexNumber & 0xFF) >> 0) / 255

      return Color(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }

    return nil
  }
}
