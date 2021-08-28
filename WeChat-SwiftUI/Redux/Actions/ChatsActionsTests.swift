import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

// swiftlint:disable force_cast
final class ChatsActionsTests: XCTestCase, ReduxTestCase {

  private var mockStore: MockStore!

  override func setUp() {
    super.setUp()
    mockStore = MockStore(initialState: .preview, reducer: appStateReducer)
  }

  override func tearDown() {
    super.tearDown()
    mockStore = nil
  }

  func test_sendMessageInDialog_dialogIsNotSavedToServer() {
    let message = Message(text: "Hello")
    let dialog = Dialog(members: [.template1, .template2], messages: [message])

    let appState = preparedAppState(with: [dialog])
    mockStore = MockStore(initialState: appState, reducer: appStateReducer)

    let mockService = FirestoreServiceMock(overrideDialogError: nil)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.SendMessageInDialog(message: message, dialog: dialog))

      wait {
        XCTAssertEqual(self.mockStore.actions.count, 4)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.SendMessageInDialog,
          ChatsActions.SendMessageInDialog(message: message, dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! ChatsActions.InsertMessageToDialog,
          ChatsActions.InsertMessageToDialog(message: message.setStatus(.sending), dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[2] as! ChatsActions.SetDialogIsSavedToServer,
          ChatsActions.SetDialogIsSavedToServer(dialog: dialog, isSaved: true)
        )
        XCTAssertEqual(
          self.mockStore.actions[3] as! ChatsActions.SetMessageStatusInDialog,
          ChatsActions.SetMessageStatusInDialog(message: message, status: .sent, dialog: dialog)
        )
      }
    }
  }

  func test_sendMessageInDialog_dialogIsSavedToServer() {
    let message = Message(text: "Hello")
    let dialog = Dialog(members: [.template1, .template2], messages: [message], isSavedToServer: true)

    let appState = preparedAppState(with: [dialog])
    mockStore = MockStore(initialState: appState, reducer: appStateReducer)

    let mockService = FirestoreServiceMock(insertMessageError: nil)

    withEnvironment(firestoreService: mockService) {
      mockStore.dispatch(action: ChatsActions.SendMessageInDialog(message: message, dialog: dialog))

      wait {
        XCTAssertEqual(self.mockStore.actions.count, 3)
        XCTAssertEqual(
          self.mockStore.actions[0] as! ChatsActions.SendMessageInDialog,
          ChatsActions.SendMessageInDialog(message: message, dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[1] as! ChatsActions.InsertMessageToDialog,
          ChatsActions.InsertMessageToDialog(message: message.setStatus(.sending), dialog: dialog)
        )
        XCTAssertEqual(
          self.mockStore.actions[2] as! ChatsActions.SetMessageStatusInDialog,
          ChatsActions.SetMessageStatusInDialog(message: message, status: .sent, dialog: dialog)
        )
      }
    }
  }
}
