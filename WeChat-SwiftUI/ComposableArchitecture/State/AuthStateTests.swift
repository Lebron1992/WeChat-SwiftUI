import XCTest
@testable import WeChat_SwiftUI

final class AuthStateTests: XCTestCase {

  func test_equals() {
    let state1 = AuthState(signedInUser: nil)
    let state2 = AuthState(signedInUser: .template1)
    XCTAssertEqual(state1, state1)
    XCTAssertEqual(state2, state2)
    XCTAssertNotEqual(state1, state2)
  }
}
