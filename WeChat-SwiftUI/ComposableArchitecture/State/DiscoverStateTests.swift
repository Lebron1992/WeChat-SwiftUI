import XCTest
@testable import WeChat_SwiftUI

final class DiscoverStateTests: XCTestCase {

  func test_equals() {
    let state1 = DiscoverState(discoverSections: DiscoverSection.allCases)
    let state2 = DiscoverState(discoverSections: [])
    XCTAssertEqual(state1, state1)
    XCTAssertEqual(state2, state2)
    XCTAssertNotEqual(state1, state2)
  }
}
