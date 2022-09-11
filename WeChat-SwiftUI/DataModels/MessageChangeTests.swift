import XCTest
@testable import WeChat_SwiftUI

final class MessageChangeTests: XCTestCase {
  func test_equatable() {
    let mc1 = MessageChange(message: .textTemplate1, changeType: .added)
    let mc2 = MessageChange(message: .textTemplate1, changeType: .modified)
    let mc3 = MessageChange(message: .textTemplate2, changeType: .modified)
    XCTAssertEqual(mc1, mc1)
    XCTAssertEqual(mc2, mc2)
    XCTAssertEqual(mc3, mc3)
    XCTAssertNotEqual(mc1, mc2)
    XCTAssertNotEqual(mc2, mc3)
  }
}
