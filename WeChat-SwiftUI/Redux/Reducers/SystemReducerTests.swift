import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class SystemReducerTests: XCTestCase {

  private var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    store = Store(initialState: AppState(), reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    store = nil
  }

  func test_handleSetShowLoading() {
    store.dispatch(action: SystemActions.SetShowLoading(showLoading: true))
    XCTAssertEqual(store.state.systemState.showLoading, true)

    store.dispatch(action: SystemActions.SetShowLoading(showLoading: false))
    XCTAssertEqual(store.state.systemState.showLoading, false)
  }

  func test_handleSetErrorMessage() {
    store.dispatch(action: SystemActions.SetErrorMessage(message: "something went wrong"))
    XCTAssertEqual(store.state.systemState.errorMessage, "something went wrong")

    store.dispatch(action: SystemActions.SetErrorMessage(message: nil))
    XCTAssertEqual(store.state.systemState.errorMessage, nil)
  }
}
