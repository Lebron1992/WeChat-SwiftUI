import Foundation

struct ChatsState: Codable, Equatable {
  var dialogs: [Dialog]
}

// MARK: - Mutation
extension ChatsState {
  mutating func insert(_ message: Message, to dialog: Dialog) {

    let newDialog = dialogs
      .element(matching: dialog)
      .insert(message)

    if let index = dialogs.index(matching: newDialog) {
      dialogs[index] = newDialog
    } else {
      dialogs.append(newDialog)
    }

    dialogs.sort()
  }

  mutating func setStatus(_ status: Message.Status, for message: Message, in dialog: Dialog) {

    guard let dIndex = dialogs.index(matching: dialog),
          let mIndex = dialogs[dIndex].messages.index(matching: message)
    else {
      return
    }

    let newMessage = dialogs[dIndex].messages[mIndex].setStatus(status)
    dialogs[dIndex] = dialogs[dIndex].setMessage(newMessage, at: mIndex)
  }

  mutating func setIsSavedToServer(_ isSaved: Bool, for dialog: Dialog) {
    guard let index = dialogs.index(matching: dialog) else {
      return
    }
    dialogs[index] = dialogs[index].setIsSavedToServer(isSaved)
  }
}

#if DEBUG
extension ChatsState {
  static var preview: ChatsState {
    ChatsState(
      dialogs: []
    )
  }
}
#endif
