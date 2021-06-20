import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class RootReducerTests: XCTestCase {

  private var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    store = Store(initialState: AppState(), reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    store = nil
  }

  func test_handleSetSelectedTab() {
    store.dispatch(action: RootActions.SetSelectedTab(tab: .chats))
    XCTAssertEqual(store.state.rootState.selectedTab, .chats)

    store.dispatch(action: RootActions.SetSelectedTab(tab: .contacts))
    XCTAssertEqual(store.state.rootState.selectedTab, .contacts)
  }
}
