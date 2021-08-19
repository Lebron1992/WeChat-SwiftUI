import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

// swiftlint:disable force_cast
final class ContactsActionsTests: XCTestCase {

  private var mockStore: MockStore!

  override func setUp() {
    super.setUp()
    mockStore = MockStore(initialState: AppState(), reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    mockStore = nil
  }

  func test_LoadContacts() {
    let contacts: [User] = [.template, .template2]
    let mockService = MockService(loadContactsResponse: contacts)
    AppEnvironment.pushEnvironment(apiService: mockService)

    mockStore.dispatch(action: ContactsActions.LoadContacts())

    wait {
      XCTAssertEqual(self.mockStore.actions.count, 3)
      XCTAssertEqual(
        self.mockStore.actions[0] as! ContactsActions.LoadContacts,
        ContactsActions.LoadContacts()
      )
      XCTAssertEqual(
        self.mockStore.actions[1] as! ContactsActions.SetContacts,
        ContactsActions.SetContacts(contacts: .isLoading(last: nil, cancelBag: CancelBag()))
      )
      XCTAssertEqual(
        self.mockStore.actions[2] as! ContactsActions.SetContacts,
        ContactsActions.SetContacts(contacts: .loaded(contacts))
      )
    }

    AppEnvironment.popEnvironment()
  }

  func test_LoadOfficialAccounts() {
    let accounts: [OfficialAccount] = [.template, .template2]
    let mockService = MockService(loadOfficialAccountsResponse: accounts)
    AppEnvironment.pushEnvironment(apiService: mockService)

    mockStore.dispatch(action: ContactsActions.LoadOfficialAccounts())

    wait {
      XCTAssertEqual(self.mockStore.actions.count, 3)
      XCTAssertEqual(
        self.mockStore.actions[0] as! ContactsActions.LoadOfficialAccounts,
        ContactsActions.LoadOfficialAccounts()
      )
      XCTAssertEqual(
        self.mockStore.actions[1] as! ContactsActions.SetOfficialAccounts,
        ContactsActions.SetOfficialAccounts(accounts: .isLoading(last: nil, cancelBag: CancelBag()))
      )
      XCTAssertEqual(
        self.mockStore.actions[2] as! ContactsActions.SetOfficialAccounts,
        ContactsActions.SetOfficialAccounts(accounts: .loaded(accounts))
      )
    }

    AppEnvironment.popEnvironment()
  }
}
