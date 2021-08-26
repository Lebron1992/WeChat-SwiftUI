import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class ChatsReducerTests: XCTestCase {

  private var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    store = Store(initialState: .preview, reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    store = nil
  }

  func test_handleAppendMessageToDialog() {
    let dialog: Dialog = .empty
    let message: Message = .textTemplate

    XCTAssertTrue(store.state.chatsState.dialogs.isEmpty)

    store.dispatch(action: ChatsActions.AppendMessageToDialog(message: message, dialog: dialog))

    wait {
      XCTAssertEqual(1, self.store.state.chatsState.dialogs.count)
    }
  }
}
