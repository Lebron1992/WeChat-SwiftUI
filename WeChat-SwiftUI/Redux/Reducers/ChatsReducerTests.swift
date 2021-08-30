import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

final class ChatsReducerTests: XCTestCase, AppStateDataSource, MessagesDataSource {

  private var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    store = Store(initialState: .preview, reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    store = nil
  }

  func test_handleSetDialogs() {
    let dialogs: [Dialog] = [.empty, .template1]

    XCTAssertTrue(store.state.chatsState.dialogs.isEmpty)

    store.dispatch(action: ChatsActions.SetDialogs(dialogs: dialogs))

    wait {
      XCTAssertEqual(dialogs, self.store.state.chatsState.dialogs)
    }
  }

  func test_handleSetMessagesForDialog_messagesInserted() {
    let (m1, m2, m3) = sortedMessages()
    let dialog = Dialog(members: [.template1, .template2])
    let appState = preparedAppState(dialogs: [dialog], dialogMessages: [])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetMessagesForDialog(messages: [m1, m2, m3], dialog: dialog))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogMessages.first!.messages,
        [m1, m2, m3]
      )
    }
  }

  func test_handleSetMessagesForDialog_messagesUpdaetd() {
    let (m1, m2, m3) = sortedMessages()

    let d1 = Dialog(members: [.template1, .template2], lastMessage: m1)
    let dm1 = DialogMessages(dialogId: d1.id, messages: [m1])

    let d2 = Dialog(members: [.template1, .template2], lastMessage: nil)
    let dm2 = DialogMessages(dialogId: d2.id, messages: [])

    let appState = preparedAppState(dialogs: [d1, d2], dialogMessages: [dm1, dm2])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetMessagesForDialog(messages: [m2, m3], dialog: d2))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogMessages.count,
        2
      )
      XCTAssertEqual(
        self.store.state.chatsState.dialogMessages.element(matching: dm1).messages,
        [m1]
      )
      XCTAssertEqual(
        self.store.state.chatsState.dialogMessages.element(matching: dm2).messages,
        [m2, m3]
      )
    }
  }

  func test_handleSetMessagesForDialog_dialogUpdated() {
    let (m1, m2, m3) = sortedMessages()
    let d = Dialog(members: [.template1, .template2], lastMessage: nil)
    let appState = preparedAppState(dialogs: [d], dialogMessages: [])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetMessagesForDialog(messages: [m1, m2, m3], dialog: d))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogs.first!.lastMessage,
        m3
      )
    }
  }

  func test_handleInsertMessageToDialog_dialogAppended() {
    let dialog: Dialog = .empty
    let message: Message = .textTemplate

    XCTAssertTrue(store.state.chatsState.dialogs.isEmpty)

    store.dispatch(action: ChatsActions.InsertMessageToDialog(message: message, dialog: dialog))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogs.first,
        dialog.setLastMessage(message)
      )
    }
  }

  func test_handleInsertMessageToDialog_dialogUpdated() {
    let (m1, m2, _) = sortedMessages()
    let d = Dialog(members: [.template1, .template2], lastMessage: m1)
    let appState = preparedAppState(dialogs: [d], dialogMessages: [])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.InsertMessageToDialog(message: m2, dialog: d))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogs.count,
        1
      )
      XCTAssertEqual(
        self.store.state.chatsState.dialogs.first,
        d.setLastMessage(m2)
      )
    }
  }

  func test_handleInsertMessageToDialog_dialogInserted() {
    let (m1, m2, m3) = sortedMessages()
    let d1 = Dialog(members: [.template1, .template2], lastMessage: m1)
    let d2 = Dialog(members: [.template1, .template2], lastMessage: nil)
    let d3 = Dialog(members: [.template1, .template2], lastMessage: m3)

    let appState = preparedAppState(dialogs: [d3, d1], dialogMessages: [])
    store = Store(initialState: appState, reducer: appStateReducer)
    store.dispatch(action: ChatsActions.InsertMessageToDialog(message: m2, dialog: d2))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogs,
        [d3, d2.setLastMessage(m2), d1]
      )
    }
  }

  func test_handleInsertMessageToDialog_dialogMessagesUpdated() {
    let (m1, m2, m3) = sortedMessages()

    let d1 = Dialog(members: [.template1, .template2], lastMessage: m1)
    let dm1 = DialogMessages(dialogId: d1.id, messages: [m1])

    let d2 = Dialog(members: [.template1, .template2], lastMessage: m2)
    let dm2 = DialogMessages(dialogId: d2.id, messages: [m2])

    let appState = preparedAppState(dialogs: [d1, d2], dialogMessages: [dm1, dm2])
    store = Store(initialState: appState, reducer: appStateReducer)
    store.dispatch(action: ChatsActions.InsertMessageToDialog(message: m3, dialog: d2))

    wait {
      XCTAssertEqual(
        self.store.state.chatsState.dialogMessages.first(where: { $0.id == d1.id })?.messages,
        [m1]
      )
      XCTAssertEqual(
        self.store.state.chatsState.dialogMessages.first(where: { $0.id == d2.id })?.messages,
        [m2, m3]
      )
    }
  }

  func test_handleInsertMessageToDialog_dialogMessagesGotSorted() {
    let (m1, m2, m3) = sortedMessages()
    let d = Dialog(members: [.template1, .template2], lastMessage: m1)
    let dm = DialogMessages(dialogId: d.id, messages: [m1, m3])
    let appState = preparedAppState(dialogs: [d], dialogMessages: [dm])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.InsertMessageToDialog(message: m2, dialog: d))

    wait {
      XCTAssertEqual(self.store.state.chatsState.dialogMessages.first!.messages, [m1, m2, m3])
    }
  }

  func test_handleSetMessageStatusInDialog() {
    let message = Message(text: "Hello")
    let dialog = Dialog(members: [.template1, .template2])
    let dialogMessages = DialogMessages(dialogId: dialog.id, messages: [message])

    let appState = preparedAppState(dialogs: [dialog], dialogMessages: [dialogMessages])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetMessageStatusInDialog(
      message: message,
      status: .sending,
      dialog: dialog
    ))

    wait {
      XCTAssertEqual(
        .sending,
        self.store.state.chatsState.dialogMessages
          .element(matching: dialogMessages)
          .messages
          .element(matching: message)
          .status
      )
    }
  }

  func test_handleSetDialogLastMessage_didSet() {
    let (m1, m2, _) = sortedMessages()
    let dialog = Dialog(members: [.template1, .template2], lastMessage: m2)
    let appState = preparedAppState(dialogs: [dialog], dialogMessages: [])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetDialogLastMessage(dialog: dialog, lastMessage: m1))

    wait {
      XCTAssertEqual(self.store.state.chatsState.dialogs.first!.lastMessage, m1)
    }
  }

  func test_handleSetDialogLastMessage_gotSorted() {
    let (m1, m2, m3) = sortedMessages()
    let d1 = Dialog(members: [.template1, .template2], lastMessage: m1)
    let d2 = Dialog(members: [.template1, .template2], lastMessage: m2)
    let appState = preparedAppState(dialogs: [d1, d2], dialogMessages: [])
    store = Store(initialState: appState, reducer: appStateReducer)

    store.dispatch(action: ChatsActions.SetDialogLastMessage(dialog: d2, lastMessage: m3))

    wait {
      XCTAssertEqual(self.store.state.chatsState.dialogs, [d2.setLastMessage(m3), d1])
    }
  }
}
