import XCTest
@testable import WeChat_SwiftUI

final class Collection_MatchingTests: XCTestCase {

  private let models: [MatchingModel] = [
    .init(value: 1),
    .init(value: 2),
    .init(value: 3),
    .init(value: 1),
    .init(value: 4)
  ]

  func test_indexMatching() {
    XCTAssertNil(models.index(matching: .init(value: 0)))
    XCTAssertEqual(0, models.index(matching: .init(value: 1)))
    XCTAssertEqual(4, models.index(matching: .init(value: 4)))
  }

  func test_elementMatching() {
    XCTAssertEqual(.init(value: 1), models.element(matching: .init(value: 1)))
    XCTAssertEqual(.init(value: 5), models.element(matching: .init(value: 5)))
  }
}

private extension Collection_MatchingTests {
  struct MatchingModel: Identifiable, Equatable {
    let value: Int
    var id: Int { value }
  }
}
