import Foundation

struct ChatsState: Codable, Equatable {
  var dialogs: [Dialog]
  var dialogMessages: Set<DialogMessages>
}

// MARK: - Mutations
extension ChatsState {
  mutating func set(_ messages: [Message], for dialog: Dialog) {
    guard messages.isEmpty == false else {
      return
    }

    // update dialogs

    let newDialog = dialogs
      .element(matching: dialog)
      .updatedLastMessage(messages.last!)
    insert(newDialog)

    // update dialogMessages

    if var existingDM = dialogMessages.first(where: { $0.dialogId == dialog.id }) {
      dialogMessages.update(with: existingDM.set(messages))
    } else {
      dialogMessages.insert(.init(dialogId: dialog.id, messages: messages))
    }
  }

  mutating func insert(_ message: Message, to dialog: Dialog) {

    // update dialogs

    let newDialog = dialogs
      .element(matching: dialog)
      .updatedLastMessage(message)
    insert(newDialog)

    // update dialogMessages

    if var existingDM = dialogMessages.first(where: { $0.dialogId == dialog.id }) {
      dialogMessages.update(with: existingDM.inserted(message))
    } else {
      dialogMessages.insert(.init(dialogId: dialog.id, messages: [message]))
    }
  }

  mutating func setStatus(_ status: Message.Status, for message: Message, in dialog: Dialog) {

    guard var existingMessages = dialogMessages.first(where: { $0.dialogId == dialog.id }),
          existingMessages.messages.contains(message)
    else {
      return
    }

    dialogMessages.update(with: existingMessages.updatedStatus(status, for: message))
  }

  mutating func setLastMessage(_ message: Message, for dialog: Dialog) {
    guard let index = dialogs.index(matching: dialog) else {
      return
    }
    dialogs[index] = dialogs[index].setLastMessage(message)
    dialogs.sort()
  }
}

// MARK: - Helper Methods
private extension ChatsState {
  mutating func insert(_ dialog: Dialog) {
    if let index = dialogs.index(matching: dialog) {
      dialogs[index] = dialog
    } else if let index = dialogs.firstIndex(where: { dialog < $0 }) {
      dialogs.insert(dialog, at: index)
    } else {
      dialogs.append(dialog)
    }
  }
}

#if DEBUG
extension ChatsState {
  static var preview: ChatsState {
    ChatsState(
      dialogs: [],
      dialogMessages: []
    )
  }
}
#endif
