import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class AuthReducerTests: XCTestCase {
  
  private var store: Store<AppState>!
  
  override func setUp() {
    super.setUp()
    store = Store(initialState: AppState(), reducer: appStateReducer)
  }
  
  override func tearDown() {
    super.tearDown()
    store = nil
  }
  
  func test_handleSetSignedInUser() {
    store.dispatch(action: AuthActions.SetSignedInUser(user: .template))
    XCTAssertEqual(store.state.authState.signedInUser, .template)
    
    store.dispatch(action: AuthActions.SetSignedInUser(user: nil))
    XCTAssertEqual(store.state.authState.signedInUser, nil)
  }
}
