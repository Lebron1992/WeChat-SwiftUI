import Foundation

struct ChatsState: Codable, Equatable {
  var dialogs: [Dialog]
  var dialogMessages: Set<DialogMessages>
}

// MARK: - Mutations
extension ChatsState {
  mutating func updateDialogs(with dialogChanges: [DialogChange]) {
    dialogChanges.forEach { change in
      switch change.changeType {
      case .added, .modified:
        self.insert(change.dialog)
      case .removed:
        self.remove(change.dialog)
      }
    }
  }

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
      dialogMessages.update(with: existingDM.setMessages(messages))
    } else {
      dialogMessages.insert(.init(dialogId: dialog.id, messages: messages))
    }
  }

  mutating func updateMessages(with messageChanges: [MessageChange], for dialog: Dialog) {
    messageChanges.forEach { change in
      switch change.changeType {
      case .added, .modified:
        self.insert(change.message, to: dialog)
      case .removed:
        self.remove(change.message, from: dialog)
      }
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
      dialogMessages.update(with: existingDM.insertedMessage(message))
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
      dialogs.sort()
    } else if let index = dialogs.firstIndex(where: { dialog < $0 }) {
      dialogs.insert(dialog, at: index)
    } else {
      dialogs.append(dialog)
    }
  }

  mutating func remove(_ dialog: Dialog) {
    dialogs.removeAll(where: { $0.id == dialog.id })
  }

  mutating func remove(_ message: Message, from dialog: Dialog) {
    guard var existingDM = dialogMessages.first(where: { $0.dialogId == dialog.id }) else {
      return
    }
    let newDM = existingDM.removedMessage(message)
    dialogMessages.update(with: newDM)

    // update dialog's last message

    if let dialogIndex = dialogs.index(matching: dialog),
       dialogs[dialogIndex].lastMessage == message,
       let lastMessage = newDM.messages.last {
      dialogs[dialogIndex] = dialogs[dialogIndex].updatedLastMessage(lastMessage)
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
