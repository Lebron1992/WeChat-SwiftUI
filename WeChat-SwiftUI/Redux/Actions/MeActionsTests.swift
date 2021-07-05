import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

// swiftlint:disable force_cast
final class MeActionsTests: XCTestCase {

  private var mockStore: MockStore!

  override func setUp() {
    super.setUp()
    mockStore = MockStore(initialState: AppState(), reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    mockStore = nil
  }

  func test_LoadUserSelf() {
    let userSelf = User.template!
    let mockService = MockService(loadUserSelfResponse: userSelf)
    AppEnvironment.pushEnvironment(apiService: mockService)

    mockStore.dispatch(action: MeActions.LoadUserSelf())

    XCTAssertEqual(mockStore.actions.count, 3)
    XCTAssertEqual(
      mockStore.actions[0] as! MeActions.LoadUserSelf,
        MeActions.LoadUserSelf()
    )
    XCTAssertEqual(
      mockStore.actions[1] as! MeActions.SetUserSelf,
        MeActions.SetUserSelf(userSelf: .isLoading(last: nil, cancelBag: CancelBag()))
    )
    XCTAssertEqual(
      mockStore.actions[2] as! MeActions.SetUserSelf,
        MeActions.SetUserSelf(userSelf: .loaded(userSelf))
    )

    AppEnvironment.popEnvironment()
  }
}
