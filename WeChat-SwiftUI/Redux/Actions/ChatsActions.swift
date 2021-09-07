import SwiftUIRedux
import Foundation

enum ChatsActions {
  private static let cancelBag = CancelBag()

  struct LoadDialogs: AsyncAction, Equatable {
    func async(dispatch: @escaping Dispatch, state: ReduxState?) {
      AppEnvironment.current.firestoreService
        .loadDialogs()
        .sinkToResultForUI { result in
          switch result {
          case .success(let dialogs):
            dispatch(SetDialogs(dialogs: dialogs))
          case .failure(let error):
            dispatch(SystemActions.SetErrorMessage(message: error.localizedDescription))
          }
        }
        .store(in: cancelBag)
    }
  }

  struct SetDialogs: Action, Equatable {
    let dialogs: [Dialog]
  }

  struct UpdateDialogs: Action, Equatable {
    let dialogChanges: [DialogChange]
  }

  struct LoadMessagesForDialog: AsyncAction, Equatable {
    let dialog: Dialog

    func async(dispatch: @escaping Dispatch, state: ReduxState?) {
      AppEnvironment.current.firestoreService
        .loadMessages(for: dialog)
        .sinkToResultForUI { result in
          switch result {
          case .success(let messages):
            dispatch(SetMessagesForDialog(messages: messages, dialog: dialog))
          case .failure(let error):
            dispatch(SystemActions.SetErrorMessage(message: error.localizedDescription))
          }
        }
        .store(in: cancelBag)
    }
  }

  struct SetMessagesForDialog: Action, Equatable {
    let messages: [Message]
    let dialog: Dialog
  }

  struct UpdateMessagesForDialog: Action, Equatable {
    let messageChanges: [MessageChange]
    let dialog: Dialog
  }

  struct SendTextMessageInDialog: AsyncAction, Equatable {
    let message: Message
    let dialog: Dialog

    func async(dispatch: @escaping Dispatch, state: ReduxState?) {
      let sendingMessage = message.setStatus(.sending)
      let sentMessage = message.setStatus(.sent)

      dispatch(InsertMessageToDialog(
        message: sendingMessage,
        dialog: dialog
      ))

      AppEnvironment.current.firestoreService
        .insert(sentMessage, to: dialog)
        .sinkToResultForUI { result in
          switch result {
          case .success:
            // 保存 message 成功后再更新 dialog，实际开发中应该通过一个请求完成
            let newDialog = dialog.updatedLastMessage(sentMessage)
            AppEnvironment.current.firestoreService
              .overrideDialog(newDialog)
              .sinkToResultForUI { result in
                switch result {
                case .success:
                  dispatch(SetMessageStatusInDialog(
                    message: sendingMessage,
                    status: .sent,
                    dialog: dialog
                  ))
                  dispatch(SetDialogLastMessage(dialog: dialog, lastMessage: sentMessage))
                case .failure(let error):
                  dispatch(SystemActions.SetErrorMessage(message: error.localizedDescription))
                }
              }
              .store(in: cancelBag)

          case .failure(let error):
            dispatch(SystemActions.SetErrorMessage(message: error.localizedDescription))
          }
        }
        .store(in: cancelBag)
    }
  }

  struct SendImageMessageInDialog: AsyncAction, Equatable {

    let message: Message
    let dialog: Dialog
    let storageService: FirebaseStorageServiceType

    init(
      message: Message,
      dialog: Dialog,
      storageService: FirebaseStorageServiceType = FirebaseStorageService()
    ) {
      self.message = message
      self.dialog = dialog
      self.storageService = storageService
    }

    static func == (lhs: ChatsActions.SendImageMessageInDialog, rhs: ChatsActions.SendImageMessageInDialog) -> Bool {
      lhs.message == rhs.message && lhs.dialog == rhs.dialog
    }

    func async(dispatch: @escaping Dispatch, state: ReduxState?) {

      guard let uiImage = message.image?.uiImage,
            let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
        dispatch(SystemActions.SetErrorMessage(message: "无效的图片"))
        return
      }

      let sendingMessage = message.setStatus(.sending)
      dispatch(InsertMessageToDialog(
        message: sendingMessage,
        dialog: dialog
      ))

      let uploadSuccess: (URL) -> Void = { url in
        let sentMessage = message
          .setImage(
            urlImage: .init(
              url: url.absoluteString,
              width: uiImage.size.width,
              height: uiImage.size.height
            ))
          .setStatus(.sent)

        // 2. 获得图片 URL 后保存 message，
        AppEnvironment.current.firestoreService
          .insert(sentMessage, to: dialog)
          .sinkToResultForUI { result in
            switch result {
            case .success:
              // 3. 更新 dialog
              // 保存 message 成功后再更新 dialog，实际开发中应该通过一个请求完成
              let newDialog = dialog.updatedLastMessage(sentMessage)
              AppEnvironment.current.firestoreService
                .overrideDialog(newDialog)
                .sinkToResultForUI { result in
                  switch result {
                  case .success:
                    dispatch(InsertMessageToDialog(
                      message: sentMessage,
                      dialog: dialog
                    ))
                    dispatch(SetDialogLastMessage(dialog: dialog, lastMessage: sentMessage))
                  case .failure(let error):
                    dispatch(SystemActions.SetErrorMessage(message: error.localizedDescription))
                  }
                }
                .store(in: cancelBag)

            case .failure(let error):
              dispatch(SystemActions.SetErrorMessage(message: error.localizedDescription))
            }
          }
          .store(in: cancelBag)
      }

      // 1. 上传图片
      storageService.uploadImageData(
        imageData,
        for: message,
        in: .png,
        progress: { progress in
          let message = sendingMessage.setLocalImageStatus(.uploading(progress: Float(progress)))
          dispatch(InsertMessageToDialog(
            message: message,
            dialog: dialog
          ))
        }
      )
        .sinkToResultForUI(completion: { result in
          switch result {
          case .success(let url):
            uploadSuccess(url)
          case .failure(let error):
            let failedMessage = message.setLocalImageStatus(.failed(error))
            dispatch(InsertMessageToDialog(
              message: failedMessage,
              dialog: dialog
            ))
          }
        })
        .store(in: cancelBag)
    }
  }

  struct InsertMessageToDialog: Action, Equatable {
    let message: Message
    let dialog: Dialog
  }

  struct SetMessageStatusInDialog: Action, Equatable {
    let message: Message
    let status: Message.Status
    let dialog: Dialog
  }

  struct SetDialogLastMessage: Action, Equatable {
    let dialog: Dialog
    let lastMessage: Message
  }
}
