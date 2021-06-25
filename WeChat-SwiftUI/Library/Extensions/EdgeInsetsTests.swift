import SwiftUI
import XCTest
@testable import WeChat_SwiftUI

final class EdgeInsetsTests: XCTestCase {

  func test_zero() {
    XCTAssertEqual(EdgeInsets.zero.top, 0)
    XCTAssertEqual(EdgeInsets.zero.leading, 0)
    XCTAssertEqual(EdgeInsets.zero.bottom, 0)
    XCTAssertEqual(EdgeInsets.zero.trailing, 0)
  }
}
