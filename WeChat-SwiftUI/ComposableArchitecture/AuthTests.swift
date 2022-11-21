@testable import WeChat_SwiftUI
import XCTest
import ComposableArchitecture

@MainActor
final class AuthActionsTests: XCTestCase {

  func test_loadUserSelf_success() async {
    let user = User.template1!
    let mockService = FirestoreServiceMock(loadUserSelfResponse: user)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(authState: .preview),
        reducer: appReducer
      )

      await store.send(.auth(.loadUserSelf))

      await store.receive(.auth(.loadUserSelfResponse(.success(user)))) {
        $0.authState.signedInUser = user
        XCTAssertEqual(AppEnvironment.current.currentUser, user)
      }
    }
  }

  func test_setSignedInUser() async {
    let user = User.template1!
    await withEnvironmentAsync(currentUser: nil) {
      let store = TestStore(
        initialState: AppState(authState: .preview),
        reducer: appReducer
      )

      await store.send(.auth(.setSignedInUser(user))) {
        $0.authState.signedInUser = user
        XCTAssertEqual(AppEnvironment.current.currentUser, user)
      }
    }
  }
}
