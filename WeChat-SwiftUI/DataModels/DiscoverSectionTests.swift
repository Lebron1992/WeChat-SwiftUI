import XCTest
@testable import WeChat_SwiftUI

final class DiscoverSectionTests: XCTestCase {

  func test_isFirstSection() {
    DiscoverSection.allCases
      .forEach { section in
        switch section {
        case .moments:
          XCTAssertTrue(section.isFirstSection)
        default:
          XCTAssertFalse(section.isFirstSection)
        }
      }
  }
}
