import XCTest
@testable import WeChat_SwiftUI

final class DialogChangeTests: XCTestCase {
  func test_equatable() {
    let dc1 = DialogChange(dialog: .template1, changeType: .added)
    let dc2 = DialogChange(dialog: .template1, changeType: .modified)
    let dc3 = DialogChange(dialog: .template2, changeType: .modified)
    XCTAssertEqual(dc1, dc1)
    XCTAssertEqual(dc2, dc2)
    XCTAssertEqual(dc3, dc3)
    XCTAssertNotEqual(dc1, dc2)
    XCTAssertNotEqual(dc2, dc3)
  }
}
