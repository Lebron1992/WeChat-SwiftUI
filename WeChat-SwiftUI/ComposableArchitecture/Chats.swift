import UIKit
import ComposableArchitecture

enum ChatsAction: Equatable {
  case loadDialogs
  case loadDialogsResponse(Result<[Dialog], ErrorEnvelope>)
  case updateDialogs([DialogChange])

  case loadMessagesForDialog(Dialog)
  case loadMessagesForDialogResponse(Dialog, Result<[Message], ErrorEnvelope>)
  case updateMessagesForDialog([MessageChange], Dialog)

  case sendTextMessageInDialog(Message, Dialog)
  case sendImageMessageInDialog(Message, Dialog)
  case sendMessageInDialogResponse(Message, Dialog, Result<Success, ErrorEnvelope>)
  case overrideDialogResponse(Dialog, Message, Result<Success, ErrorEnvelope>)
  case uploadImageForMessageInDialogResponse(Message, Dialog, Result<URL, ErrorEnvelope>)
}

let chatsReducer = Reducer<ChatsState, ChatsAction, Environment> { state, action, _ in
  switch action {
  case .loadDialogs:
    struct LoadDialogsId: Hashable {}
    return AppEnvironment.current.firestoreService
      .loadDialogs()
      .catchToEffect(ChatsAction.loadDialogsResponse)
      .cancellable(id: LoadDialogsId(), cancelInFlight: true)

  case let .loadDialogsResponse(result):
    if let dialogs = try? result.get(), dialogs.isEmpty == false {
      state.dialogs = dialogs.sorted()
    }
    return .none

  case let .updateDialogs(changes):
    state.updateDialogs(with: changes)
    return .none

  case let .loadMessagesForDialog(dialog):
    struct LoadMessagesForDialogId: Hashable {
      let dialogId: String
    }
    return AppEnvironment.current.firestoreService
      .loadMessages(for: dialog)
      .catchToEffect { ChatsAction.loadMessagesForDialogResponse(dialog, $0) }
      .cancellable(id: LoadMessagesForDialogId(dialogId: dialog.id), cancelInFlight: true)

  case let .loadMessagesForDialogResponse(dialog, result):
    if let messages = try? result.get(), messages.isEmpty == false {
      state.set(messages.sorted(), for: dialog)
    }
    return .none

  case let .updateMessagesForDialog(changes, dialog):
    state.updateMessages(with: changes, for: dialog)
    return .none

  case let .sendTextMessageInDialog(message, dialog):
    let sendingMessage = message.setStatus(.sending)
    let sentMessage = message.setStatus(.sent)

    // 把新的 message 插入到缓存中
    state.insert(sendingMessage, to: dialog)

    return AppEnvironment.current.firestoreService
      .insert(sentMessage, to: dialog)
      .catchToEffect { ChatsAction.sendMessageInDialogResponse(sentMessage, dialog, $0) }
      .cancellable(id: SendMessageInDialogId(messageId: message.id, dialogId: dialog.id), cancelInFlight: true)

  case let .sendImageMessageInDialog(message, dialog):
    guard let uiImage = message.image?.uiImage,
          let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
      return .init(value: ChatsAction.sendMessageInDialogResponse(
        message, dialog, .failure(NSError.commonError(description: "无效的图片").toEnvelope()))
      )
    }

    struct SendImageMessageInDialog: Hashable {
      let data: Data
      let messageId: String
      let dialogId: String
    }

    let sendingMessage = message.setStatus(.sending)

    // 把新的 message 插入到缓存中
    state.insert(sendingMessage, to: dialog)

    return AppEnvironment.current.firebaseStorageService
      .uploadImageData(
        imageData,
        for: message,
        in: .png,
        progress: { progress in
          // TODO: how to handle this?
        }
      )
      .catchToEffect { ChatsAction.uploadImageForMessageInDialogResponse(message, dialog, $0) }
      .cancellable(
        id: SendImageMessageInDialog(data: imageData, messageId: message.id, dialogId: dialog.id),
        cancelInFlight: true
      )

  case let .uploadImageForMessageInDialogResponse(message, dialog, result):
    switch result {
    case .success(let url):
      let sentMessage = message
        .setImage(
          urlImage: .init(
            url: url.absoluteString,
            width: message.image!.size.width,
            height: message.image!.size.height
          ))
        .setStatus(.sent)
      return AppEnvironment.current.firestoreService
        .insert(sentMessage, to: dialog)
        .catchToEffect { ChatsAction.sendMessageInDialogResponse(sentMessage, dialog, $0) }
        .cancellable(id: SendMessageInDialogId(messageId: message.id, dialogId: dialog.id), cancelInFlight: true)

    case .failure(let error):
      let failedMessage = message
        .setLocalImageStatus(.failed(error))
        .setStatus(.sent)
      state.insert(failedMessage, to: dialog)
      return .none
    }

  case let .sendMessageInDialogResponse(message, dialog, result):
    switch result {
    case .success:
      struct OverrideDialogId: Hashable {
        let dialogId: String
      }

      state.setStatus(.sent, for: message, in: dialog)
      state.setLastMessage(message, for: dialog)

      let newDialog = dialog.updatedLastMessage(message)
      return AppEnvironment.current.firestoreService
        .overrideDialog(newDialog)
        .catchToEffect { ChatsAction.overrideDialogResponse(dialog, message, $0) }
        .cancellable(id: OverrideDialogId(dialogId: dialog.id), cancelInFlight: true)
    case .failure:
      // TODO: 把消息标记为发送失败
      return .none
    }

  case let .overrideDialogResponse(dialog, lastMessage, result):
    if case .success = result {
      state.setLastMessage(lastMessage, for: dialog)
    }
    return .none
  }
}

private struct SendMessageInDialogId: Hashable {
  let messageId: String
  let dialogId: String
}
