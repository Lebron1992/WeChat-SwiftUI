import SwiftUIRedux

enum ChatsActions {
  private static let cancelBag = CancelBag()

  struct SendMessageInDialog: AsyncAction, Equatable {
    let message: Message
    let dialog: Dialog

    func async(dispatch: @escaping Dispatch, state: ReduxState?) {
      dispatch(InsertMessageToDialog(
        message: message.setStatus(.sending),
        dialog: dialog
      ))

      if dialog.isSavedToServer {
        AppEnvironment.current.firestoreService
          .insert(message, to: dialog)
          .sinkToResultForUI { result in
            switch result {
            case .success:
              dispatch(SetMessageStatusInDialog(
                message: message,
                status: .sent,
                dialog: dialog
              ))
            case .failure(let error):
              // TODO: 错误处理
              print("[SendMessageInDialog] insert message error: \(error.localizedDescription)")
            }
          }
          .store(in: cancelBag)

      } else {
        let newDialog = dialog.insert(message)
        AppEnvironment.current.firestoreService
          .overrideDialog(newDialog)
          .sinkToResultForUI { result in
            switch result {
            case .success:
              dispatch(SetDialogIsSavedToServer(dialog: dialog, isSaved: true))
              dispatch(SetMessageStatusInDialog(
                message: message,
                status: .sent,
                dialog: dialog
              ))
            case .failure(let error):
              // TODO: 错误处理
              print("[SendMessageInDialog] override dialog error: \(error.localizedDescription)")
            }
          }
          .store(in: cancelBag)
      }
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

  struct SetDialogIsSavedToServer: Action, Equatable {
    let dialog: Dialog
    let isSaved: Bool
  }
}
