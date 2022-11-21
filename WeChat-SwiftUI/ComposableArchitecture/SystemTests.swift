@testable import WeChat_SwiftUI
import XCTest
import ComposableArchitecture

@MainActor
final class SystemTests: XCTestCase {

  func test_setErrorMessage() async {
    let store = TestStore(
      initialState: AppState(systemState: .preview),
      reducer: appReducer
    )
    let errorMessage = "system message"
    await store.send(AppAction.system(.setErrorMessage(errorMessage))) {
      $0.systemState.errorMessage = errorMessage
    }
  }
}
