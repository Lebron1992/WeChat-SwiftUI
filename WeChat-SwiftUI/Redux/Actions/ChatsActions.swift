import SwiftUIRedux

enum ChatsActions {
  struct AppendMessageToDialog: Action, Equatable {
    let message: Message
    let dialog: Dialog
  }
}
