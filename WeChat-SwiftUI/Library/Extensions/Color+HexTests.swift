import XCTest
import SwiftUI
@testable import WeChat_SwiftUI

final class Color_HexTests: XCTestCase {
  func testColors() {
    var red = Color.hex(0xFF0000)
    var green = Color.hex(0x00FF00)
    var blue = Color.hex(0x0000FF)

    XCTAssertEqual(Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0), red)
    XCTAssertEqual(Color(red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0), green)
    XCTAssertEqual(Color(red: 0.0, green: 0.0, blue: 1.0, opacity: 1.0), blue)

    red = Color.hex("#FF0000")!
    green = Color.hex("#00FF00")!
    blue = Color.hex("#0000FF")!

    XCTAssertEqual(Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0), red)
    XCTAssertEqual(Color(red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0), green)
    XCTAssertEqual(Color(red: 0.0, green: 0.0, blue: 1.0, opacity: 1.0), blue)

    red = Color.hex("FF0000")!
    green = Color.hex("00FF00")!
    blue = Color.hex("0000FF")!

    XCTAssertEqual(Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0), red)
    XCTAssertEqual(Color(red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0), green)
    XCTAssertEqual(Color(red: 0.0, green: 0.0, blue: 1.0, opacity: 1.0), blue)
  }
}
