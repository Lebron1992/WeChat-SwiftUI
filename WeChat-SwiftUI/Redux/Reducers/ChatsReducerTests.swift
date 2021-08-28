import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class ChatsReducerTests: XCTestCase, ReduxTestCase {

  private var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    store = Store(initialState: .preview, reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    store = nil
  }

  func test_handleInsertMessageToDialog() {
    let dialog: Dialog = .empty
    let message: Message = .textTemplate

    XCTAssertTrue(store.state.chatsState.dialogs.isEmpty)

    store.dispatch(action: ChatsActions.InsertMessageToDialog(message: message, dialog: dialog))

    wait {
      XCTAssertEqual(1, self.store.state.chatsState.dialogs.count)
    }
  }

  func test_setMessageStatusInDialog() {
    let message = Message(text: "Hello")
    let dialog = Dialog(members: [.template1, .template2], messages: [message])

    let appState = preparedAppState(with: [dialog])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetMessageStatusInDialog(
      message: message,
      status: .sending,
      dialog: dialog
    ))

    wait {
      XCTAssertEqual(
        .sending,
        self.store.state.chatsState.dialogs.element(matching: dialog).messages.first!.status
      )
    }
  }

  func test_setDialogIsSavedToServer() {
    let dialog = Dialog(members: [.template1, .template2])

    let appState = preparedAppState(with: [dialog])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetDialogIsSavedToServer(dialog: dialog, isSaved: true))

    wait {
      XCTAssertTrue(self.store.state.chatsState.dialogs.first!.isSavedToServer)
    }
  }
}
