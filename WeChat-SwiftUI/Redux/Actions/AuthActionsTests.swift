import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

// swiftlint:disable force_cast
final class AuthActionsTests: XCTestCase {

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
    let user = User.template
    let mockService = FirestoreServiceMock(loadUserSelfResponse: user)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: AuthActions.LoadUserSelf())

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        XCTAssertEqual(self.mockStore.actions.count, 2)
        XCTAssertEqual(
          self.mockStore.actions[0] as! AuthActions.LoadUserSelf,
          AuthActions.LoadUserSelf()
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! AuthActions.SetSignedInUser,
          AuthActions.SetSignedInUser(user)
        )
      }
    }
  }
}
