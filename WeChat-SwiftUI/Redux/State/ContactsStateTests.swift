import XCTest
@testable import WeChat_SwiftUI

final class ContactsStateTests: XCTestCase {

  func test_equals() {
    let state1 = ContactsState(
      categories: ContactCategory.allCases,
      contacts: .notRequested,
      officialAccounts: .notRequested
    )
    let state2 = ContactsState(
      categories: [],
      contacts: .isLoading(last: nil, cancelBag: CancelBag()),
      officialAccounts: .isLoading(last: nil, cancelBag: CancelBag())
    )
    XCTAssertEqual(state1, state1)
    XCTAssertEqual(state2, state2)
    XCTAssertNotEqual(state1, state2)
  }
}
