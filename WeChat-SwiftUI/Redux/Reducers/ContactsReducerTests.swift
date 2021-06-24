import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class ContactsReducerTests: XCTestCase {

  private var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    store = Store(initialState: AppState(), reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    store = nil
  }

  func test_handleSetContacts() {
    let contacts: Loadable<[User]> = .loaded([.template, .template2])
    store.dispatch(action: ContactsActions.SetContacts(contacts: contacts))
    XCTAssertEqual(store.state.contactsState.contacts, contacts)
  }

  func test_handleSetSearchText() {
    let text = "hello"
    store.dispatch(action: ContactsActions.SetSearchText(searchText: text))
    XCTAssertEqual(store.state.contactsState.searchText, text)
  }
}
