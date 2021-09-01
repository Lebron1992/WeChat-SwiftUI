import SwiftUIRedux

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

  struct SendMessageInDialog: AsyncAction, Equatable {
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
