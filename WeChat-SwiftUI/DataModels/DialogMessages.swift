import Foundation

struct DialogMessages: Codable {
  let dialogId: String
  private(set) var messages: [Message]
}

// MARK: - Mutations
extension DialogMessages {

  @discardableResult
  mutating func set(_ messages: [Message]) -> DialogMessages {
    self.messages = messages
    return self
  }

  @discardableResult
  mutating func inserted(_ message: Message) -> DialogMessages {
    if let index = messages.index(matching: message) {
      messages[index] = message
    } else if let index = messages.firstIndex(where: { message.createTime < $0.createTime  }) {
      messages.insert(message, at: index)
    } else {
      messages.append(message)
    }
    return self
  }

  @discardableResult
  mutating func removed(_ message: Message) -> DialogMessages {
    messages.removeAll { $0.id == message.id }
    return self
  }

  @discardableResult
  mutating func updatedStatus(_ status: Message.Status, for message: Message) -> DialogMessages {
    guard let index = messages.firstIndex(of: message) else {
      return self
    }
    messages[index] = message.setStatus(status)
    return self
  }
}

extension DialogMessages: Equatable {
  static func == (lhs: DialogMessages, rhs: DialogMessages) -> Bool {
    lhs.dialogId == rhs.dialogId
  }
}

extension DialogMessages: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(dialogId)
  }
}

extension DialogMessages: Identifiable {
  var id: String {
    dialogId
  }
}
