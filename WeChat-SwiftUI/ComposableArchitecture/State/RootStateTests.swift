import XCTest
@testable import WeChat_SwiftUI

final class RootStateTests: XCTestCase {

  func test_equals() {
    let state1 = RootState(selectedTab: .chats)
    let state2 = RootState(selectedTab: .contacts)
    XCTAssertEqual(state1, state1)
    XCTAssertEqual(state2, state2)
    XCTAssertNotEqual(state1, state2)
  }
}
