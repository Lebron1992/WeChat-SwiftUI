import XCTest
@testable import WeChat_SwiftUI

final class ChatsStateTests: XCTestCase {

  func test_equals() {
    let state1 = ChatsState(dialogs: [.template1], dialogMessages: [.template1])
    let state2 = ChatsState(dialogs: [.template2], dialogMessages: [.template2])
    XCTAssertEqual(state1, state1)
    XCTAssertEqual(state2, state2)
    XCTAssertNotEqual(state1, state2)
  }
}
