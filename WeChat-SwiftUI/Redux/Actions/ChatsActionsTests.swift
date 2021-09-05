import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

// swiftlint:disable force_cast
final class ChatsActionsTests: XCTestCase, AppStateDataSource {

  private var mockStore: MockStore!

  override func setUp() {
    super.setUp()
    mockStore = MockStore(initialState: .preview, reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    mockStore = nil
  }

  func test_loadDialogs_success() {
    let dialogs: [Dialog] = [.empty, .template1]
    let mockService = FirestoreServiceMock(loadDialogsResponse: dialogs)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.LoadDialogs())
      wait {
        XCTAssertEqual(self.mockStore.actions.count, 2)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.LoadDialogs,
          ChatsActions.LoadDialogs()
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! ChatsActions.SetDialogs,
          ChatsActions.SetDialogs(dialogs: dialogs)
        )
      }
    }
  }

  func test_loadDialogs_failed() {
    let mockService = FirestoreServiceMock(loadDialogsError: NSError.unknowError)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.LoadDialogs())
      wait {
        XCTAssertEqual(self.mockStore.actions.count, 2)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.LoadDialogs,
          ChatsActions.LoadDialogs()
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! SystemActions.SetErrorMessage,
          SystemActions.SetErrorMessage(message: NSError.unknowError.localizedDescription)
        )
      }
    }
  }

  func test_loadMessagesForDialog_success() {
    let messages: [Message] = [.textTemplate, .textTemplate2]
    let mockService = FirestoreServiceMock(loadMessagesResponse: messages)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.LoadMessagesForDialog(dialog: .empty))
      wait {
        XCTAssertEqual(self.mockStore.actions.count, 2)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.LoadMessagesForDialog,
          ChatsActions.LoadMessagesForDialog(dialog: .empty)
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! ChatsActions.SetMessagesForDialog,
          ChatsActions.SetMessagesForDialog(messages: messages, dialog: .empty)
        )
      }
    }
  }

  func test_loadMessagesForDialog_failed() {
    let mockService = FirestoreServiceMock(loadMessagesError: NSError.unknowError)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.LoadMessagesForDialog(dialog: .empty))
      wait {
        XCTAssertEqual(self.mockStore.actions.count, 2)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.LoadMessagesForDialog,
          ChatsActions.LoadMessagesForDialog(dialog: .empty)
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! SystemActions.SetErrorMessage,
          SystemActions.SetErrorMessage(message: NSError.unknowError.localizedDescription)
        )
      }
    }
  }

  func test_sendTextMessageInDialog_success() {
    let message = Message(text: "Hello")
    let sendingMessage = message.setStatus(.sending)
    let sentMessage = message.setStatus(.sent)
    let dialog = Dialog(members: [.template1, .template2])
    let dialogMessages = DialogMessages(dialogId: dialog.id, messages: [message])

    let appState = preparedAppState(dialogs: [dialog], dialogMessages: [dialogMessages])
    mockStore = MockStore(initialState: appState, reducer: appStateReducer)

    let mockService = FirestoreServiceMock(insertMessageError: nil, overrideDialogError: nil)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.SendTextMessageInDialog(message: message, dialog: dialog))

      wait {
        XCTAssertEqual(self.mockStore.actions.count, 4)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.SendTextMessageInDialog,
          ChatsActions.SendTextMessageInDialog(message: message, dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! ChatsActions.InsertMessageToDialog,
          ChatsActions.InsertMessageToDialog(message: message.setStatus(.sending), dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[2] as! ChatsActions.SetMessageStatusInDialog,
          ChatsActions.SetMessageStatusInDialog(message: sendingMessage, status: .sent, dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[3] as! ChatsActions.SetDialogLastMessage,
          ChatsActions.SetDialogLastMessage(dialog: dialog, lastMessage: sentMessage)
        )
      }
    }
  }

  func test_sendTextMessageInDialog_failed() {
    let message = Message(text: "Hello")
    let dialog = Dialog(members: [.template1, .template2])
    let dialogMessages = DialogMessages(dialogId: dialog.id, messages: [message])
    let appState = preparedAppState(dialogs: [dialog], dialogMessages: [dialogMessages])
    mockStore = MockStore(initialState: appState, reducer: appStateReducer)

    let mockService = FirestoreServiceMock(insertMessageError: NSError.unknowError)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.SendTextMessageInDialog(message: message, dialog: dialog))

      wait {
        XCTAssertEqual(self.mockStore.actions.count, 3)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.SendTextMessageInDialog,
          ChatsActions.SendTextMessageInDialog(message: message, dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! ChatsActions.InsertMessageToDialog,
          ChatsActions.InsertMessageToDialog(message: message.setStatus(.sending), dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[2] as! SystemActions.SetErrorMessage,
          SystemActions.SetErrorMessage(message: NSError.unknowError.localizedDescription)
        )
      }
    }
  }
}
