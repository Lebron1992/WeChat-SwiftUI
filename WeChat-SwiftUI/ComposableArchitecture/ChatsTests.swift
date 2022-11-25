@testable import WeChat_SwiftUI
import XCTest
import ComposableArchitecture

@MainActor
final class ChatsTests: XCTestCase, AppStateDataSource {

  func test_loadDialogs_success() async {
    let dialogs: [Dialog] = [.template1, .template2].sorted()
    let mockService = FirestoreServiceMock(loadDialogsResponse: dialogs)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(chatsState: .preview),
        reducer: appReducer
      )

      await store.send(.chats(.loadDialogs))

      await store.receive(.chats(.loadDialogsResponse(.success(dialogs)))) {
        $0.chatsState.dialogs = dialogs
      }
    }
  }

  func test_loadDialogs_failed() async {
    let error = NSError.commonError(description: "failed to load dialogs")
    let mockService = FirestoreServiceMock(loadDialogsError: error)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(chatsState: .preview),
        reducer: appReducer
      )

      await store.send(.chats(.loadDialogs))

      await store.receive(.chats(.loadDialogsResponse(.failure(error)))) {
        $0.systemState.errorMessage = error.localizedDescription
      }
    }
  }

  func test_updateDialogs_added() async {
    let dialogs: [Dialog] = [.template1, .template2].sorted()
    let changes: [DialogChange] = dialogs.map { .init(dialog: $0, changeType: .added) }
    let store = TestStore(
      initialState: AppState(chatsState: .preview),
      reducer: appReducer
    )

    await store.send(.chats(.updateDialogs(changes))) {
      $0.chatsState.dialogs = dialogs
    }
  }

  func test_updateDialogs_modified() async {
    let toBeUpdated: Dialog = .template2
    let untouched: Dialog = .template1

    let updatedDialog = Dialog.template2.updatedLastMessage(.textTemplate1)
    let updated = DialogChange(dialog: updatedDialog, changeType: .modified)

    let store = TestStore(
      initialState: AppState(chatsState: .init(dialogs: [toBeUpdated, untouched], dialogMessages: [])),
      reducer: appReducer
    )

    await store.send(.chats(.updateDialogs([updated]))) {
      $0.chatsState.dialogs = [updatedDialog, untouched].sorted()
    }
  }

  func test_updateDialogs_removed() async {
    let toBeRemoved: Dialog = .template2
    let untouched: Dialog = .template1
    let removed = DialogChange(dialog: toBeRemoved, changeType: .removed)

    let store = TestStore(
      initialState: AppState(chatsState: .init(dialogs: [toBeRemoved, untouched], dialogMessages: [])),
      reducer: appReducer
    )

    await store.send(.chats(.updateDialogs([removed]))) {
      $0.chatsState.dialogs = [untouched]
    }
  }

  func test_loadMessagesForDialog_success() async {
    let dialog: Dialog = .template2
    let messages: [Message] = [.textTemplate1, .textTemplate2].sorted()
    let mockService = FirestoreServiceMock(loadMessagesResponse: messages)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
        reducer: appReducer
      )

      await store.send(.chats(.loadMessagesForDialog(dialog)))

      await store.receive(.chats(.loadMessagesForDialogResponse(dialog, .success(messages)))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(messages.last!)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: messages)]
      }
    }
  }

  func test_loadMessagesForDialog_failed() async {
    let dialog: Dialog = .template2
    let error = NSError.commonError(description: "failed to load message for dialog")
    let mockService = FirestoreServiceMock(loadMessagesError: error)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(),
        reducer: appReducer
      )

      await store.send(.chats(.loadMessagesForDialog(dialog)))

      await store.receive(.chats(.loadMessagesForDialogResponse(dialog, .failure(error)))) {
        $0.systemState.errorMessage = error.localizedDescription
      }
    }
  }

  func test_updateMessagesForDialog_added() async {
    let dialog: Dialog = .template2
    let messages: [Message] = [.textTemplate1, .textTemplate2].sorted()
    let changes: [MessageChange] = messages.map { .init(message: $0, changeType: .added) }
    let store = TestStore(
      initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
      reducer: appReducer
    )

    await store.send(.chats(.updateMessagesForDialog(changes, dialog))) {
      $0.chatsState.dialogs = [dialog.setLastMessage(messages.last!)]
      $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: messages)]
    }
  }

  func test_updateMessagesForDialog_modified() async {
    let toBeUpdated: Message = .textTemplate1.setStatus(.sending)
    let updated = toBeUpdated.setStatus(.sent)
    let untouched: Message = .textTemplate2
    let messages: [Message] = [untouched, toBeUpdated].sorted()
    let changes: [MessageChange] = [.init(message: updated, changeType: .modified)]
    let dialog = Dialog.template2.setLastMessage(toBeUpdated)

    let store = TestStore(
      initialState: AppState(
        chatsState: .init(
          dialogs: [dialog],
          dialogMessages: [.init(dialogId: dialog.id, messages: messages)])
      ),
      reducer: appReducer
    )

    await store.send(.chats(.updateMessagesForDialog(changes, dialog))) {
      $0.chatsState.dialogs = [dialog.setLastMessage(updated)]
      $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [untouched, updated])]
    }
  }

  func test_updateMessagesForDialog_removed() async {
    let toBeRemoved: Message = .textTemplate1
    let untouched: Message = .textTemplate2
    let messages: [Message] = [untouched, toBeRemoved].sorted()
    let changes: [MessageChange] = [.init(message: toBeRemoved, changeType: .removed)]
    let dialog = Dialog.template2.setLastMessage(toBeRemoved)

    let store = TestStore(
      initialState: AppState(
        chatsState: .init(
          dialogs: [dialog],
          dialogMessages: [.init(dialogId: dialog.id, messages: messages)])
      ),
      reducer: appReducer
    )

    await store.send(.chats(.updateMessagesForDialog(changes, dialog))) {
      $0.chatsState.dialogs = [dialog.setLastMessage(untouched)]
      $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [untouched])]
    }
  }

  func test_sendTextMessageInDialog_success() async {
    let message = Message(text: "Hello")
    let sendingMessage = message.setStatus(.sending)
    let sentMessage = message.setStatus(.sent)
    let dialog = Dialog(members: [.template1, .template2])

    let mockService = FirestoreServiceMock(insertMessageError: nil, overrideDialogError: nil)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
        reducer: appReducer
      )

      // 保存 text message 到服务器
      await store.send(.chats(.sendTextMessageInDialog(message, dialog))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessage)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [sendingMessage])]
      }

      await store.receive(.chats(.sendMessageInDialogResponse(sentMessage, dialog, .success(Success())))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sentMessage)]
      }

      // 更新 dialog 的 lastMessage
      await store.receive(.chats(.overrideDialogResponse(dialog, sentMessage, .success(Success()))))
    }
  }

  func test_sendTextMessageInDialog_failed() async {
    let message = Message(text: "Hello")
    let sendingMessage = message.setStatus(.sending)
    let sentMessage = message.setStatus(.sent)
    let dialog = Dialog(members: [.template1, .template2])
    let error = NSError.commonError(description: "Failed to send text message")

    let mockService = FirestoreServiceMock(insertMessageError: error)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
        reducer: appReducer
      )

      // 保存 text message 到服务器
      await store.send(.chats(.sendTextMessageInDialog(message, dialog))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessage)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [sendingMessage])]
      }

      await store.receive(.chats(.sendMessageInDialogResponse(sentMessage, dialog, .failure(error)))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessage)]
        $0.systemState.errorMessage = error.localizedDescription
      }
    }
  }

  func test_sendImageMessageInDialog_inProgress() async {
    let progress = 0.5
    let uploadingResult = UploadResult(progress: progress, url: nil)

    let message = Message(image: .uiImageTemplateIdle)
    let sendingMessage = message.setStatus(.sending)
    let sendingMessageWithProgress = sendingMessage
      .setLocalImageStatus(.uploading(progress: Float(progress)))

    let dialog = Dialog(members: [.template1, .template2])

    let mockStorageService = FirebaseStorageServiceMock(
      uploadMessageImageResponse: uploadingResult
    )

    await withEnvironmentAsync(firebaseStorageService: mockStorageService) {

      let store = TestStore(
        initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
        reducer: appReducer
      )

      await store.send(.chats(.sendImageMessageInDialog(message, dialog))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessage)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [sendingMessage])]
      }

      await store.receive(.chats(.uploadImageForMessageInDialogResponse(
        message, dialog, .success(uploadingResult)
      ))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessageWithProgress)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [sendingMessageWithProgress])]
      }
    }
  }

  func test_sendImageMessageInDialog_success() async {
    let imageUrl = "https://example.com/test.png"
    let messageImage = Message.Image.uiImageTemplateIdle
    let uploadedResult = UploadResult(progress: 1, url: URL(string: imageUrl)!)

    let message = Message(image: messageImage)
    let sendingMessage = message.setStatus(.sending)
    let sentMessage = message
      .setImage(
        urlImage: .init(
          url: imageUrl,
          width: messageImage.size.width,
          height: messageImage.size.height
        ))
      .setStatus(.sent)

    let dialog = Dialog(members: [.template1, .template2])

    let mockService = FirestoreServiceMock(insertMessageError: nil, overrideDialogError: nil)
    let mockStorageService = FirebaseStorageServiceMock(
      uploadMessageImageResponse: uploadedResult
    )

    await withEnvironmentAsync(firestoreService: mockService, firebaseStorageService: mockStorageService) {

      let store = TestStore(
        initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
        reducer: appReducer
      )

      await store.send(.chats(.sendImageMessageInDialog(message, dialog))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessage)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [sendingMessage])]
      }

      await store.receive(.chats(.uploadImageForMessageInDialogResponse(
        message, dialog, .success(uploadedResult)
      )))

      await store.receive(.chats(.sendMessageInDialogResponse(sentMessage, dialog, .success(Success())))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sentMessage)]
      }

      await store.receive(.chats(.overrideDialogResponse(dialog, sentMessage, .success(Success()))))
    }
  }

  func test_sendImageMessageInDialog_failed() async {
    let error = NSError.commonError(description: "Failed to send image message")
    let message = Message(image: .uiImageTemplateIdle)
    let sendingMessage = message.setStatus(.sending)
    let failedMessage = message
      .setLocalImageStatus(.failed(error.toEnvelope()))
      .setStatus(.sent)
    let dialog = Dialog(members: [.template1, .template2])

    let mockStorageService = FirebaseStorageServiceMock(uploadMessageImageError: error)

    await withEnvironmentAsync(firebaseStorageService: mockStorageService) {

      let store = TestStore(
        initialState: AppState(chatsState: .init(dialogs: [dialog], dialogMessages: [])),
        reducer: appReducer
      )

      await store.send(.chats(.sendImageMessageInDialog(message, dialog))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(sendingMessage)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [sendingMessage])]
      }

      await store.receive(.chats(.uploadImageForMessageInDialogResponse(
        message, dialog, .failure(error.toEnvelope())
      ))) {
        $0.chatsState.dialogs = [dialog.setLastMessage(failedMessage)]
        $0.chatsState.dialogMessages = [.init(dialogId: dialog.id, messages: [failedMessage])]
        $0.systemState.errorMessage = error.localizedDescription
      }
    }
  }
}
