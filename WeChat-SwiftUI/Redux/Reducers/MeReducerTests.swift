import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class MeReducerTests: XCTestCase {
  
  private var store: Store<AppState>!
  
  override func setUp() {
    super.setUp()
    store = Store(initialState: AppState(), reducer: appStateReducer)
  }
  
  override func tearDown() {
    super.tearDown()
    store = nil
  }
  
  func test_handleSetUserSelf() {
    store.dispatch(action: MeActions.SetUserSelf(userSelf: .template))
    XCTAssertEqual(store.state.meState.userSelf, .template)
    
    store.dispatch(action: MeActions.SetUserSelf(userSelf: .template2))
    XCTAssertEqual(store.state.meState.userSelf, .template2)
  }
}
