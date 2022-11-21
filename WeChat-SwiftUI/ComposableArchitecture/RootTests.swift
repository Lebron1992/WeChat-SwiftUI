@testable import WeChat_SwiftUI
import XCTest
import ComposableArchitecture

@MainActor
final class RootTests: XCTestCase {

  func test_setSelectedTab() async {
    let store = TestStore(
      initialState: AppState(rootState: .init(selectedTab: .chats)),
      reducer: appReducer
    )

    await store.send(AppAction.root(.setSelectedTab(.contacts))) {
      $0.rootState.selectedTab = .contacts
    }
  }
}
