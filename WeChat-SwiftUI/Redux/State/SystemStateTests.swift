import XCTest
@testable import WeChat_SwiftUI

final class SystemStateTests: XCTestCase {

  func test_equals() {
    let state1 = SystemState(showLoading: false, errorMessage: nil)
    let state2 = SystemState(showLoading: true, errorMessage: "error")
    XCTAssertEqual(state1, state1)
    XCTAssertEqual(state2, state2)
    XCTAssertNotEqual(state1, state2)
  }
}
