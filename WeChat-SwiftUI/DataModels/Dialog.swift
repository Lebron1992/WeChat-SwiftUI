import Foundation

struct Dialog: Codable, Identifiable, Equatable {
  let id: String
  let name: String?
  let members: [Member]
  let lastMessage: Message?
  let createTime: Date

  init(
    id: String,
    name: String?,
    members: [Member],
    lastMessage: Message?,
    createTime: Date
  ) {
    self.id = id
    self.name = name
    self.members = members
    self.lastMessage = lastMessage
    self.createTime = createTime
  }

  init(
    members: [Member],
    lastMessage: Message? = nil,
    createTime: Date = Date()
  ) {

    let name: String? = {
      if members.count == 2 {
        return members
          .first(where: { $0.id != AppEnvironment.current.currentUser?.id })?
          .name
      }
      return Strings.general_group_chat()
    }()

    self.init(
      id: generateUUID(),
      name: name,
      members: members,
      lastMessage: lastMessage,
      createTime: createTime
    )
  }
}

extension Dialog {
  struct Member: Codable, Equatable {
    let id: String
    let name: String
    let avatar: String?

    init(
      id: String,
      name: String,
      avatar: String?
    ) {
      self.id = id
      self.name = name
      self.avatar = avatar
    }

    init(user: User) {
      self.id = user.id
      self.name = user.name
      self.avatar = user.avatar
    }

    static var currentUser: Self? {
      guard let user = AppEnvironment.current.currentUser else {
        return nil
      }
      return .init(id: user.id, name: user.name, avatar: user.avatar)
    }
  }
}

// MARK: - Mutations
extension Dialog {
  func updatedLastMessage(_ message: Message) -> Dialog {
    if let lastMessage = lastMessage {

      if message.createTime > lastMessage.createTime || message.id == lastMessage.id {
        return setLastMessage(message)
      }

    } else {
      return setLastMessage(message)
    }

    return self
  }
}

// MARK: - Getters
extension Dialog {
  var lastMessageText: String? {
    guard let last = lastMessage else {
      return nil
    }

    if last.isTextMsg {
      return last.text
    }

    if last.isImageMsg {
      return "[\(Strings.general_photo())]"
    }

    if last.isVideoMsg {
      return "[\(Strings.general_video())]"
    }

    return nil
  }

  var lastMessageTimeString: String? {
    guard let time = lastMessage?.createTime else {
      return nil
    }
    let formatter = DateFormatter()
    formatter.dateFormat = Calendar.current.isDateInToday(time) ? "HH:mm" : "yyyy/MM/dd"
    return formatter.string(from: time)
  }

  var isIndividual: Bool {
    members.count == 2
  }

  var individualChatMember: Member? {
    guard isIndividual else {
      return nil
    }
    return members.first { $0.id != Member.currentUser?.id }
  }

  func isIndividual(with member: Member) -> Bool {
    members.count == 2 && members.contains(member)
  }

  var isSelfParticipated: Bool {
    members.contains { $0.id == Member.currentUser?.id }
  }
}

extension Dialog: Comparable {
  static func < (lhs: Dialog, rhs: Dialog) -> Bool {
    switch (lhs.lastMessage, rhs.lastMessage) {
    case (.some(let lm), .some(let rm)):
      return lm.createTime > rm.createTime
    default:
      return lhs.createTime > rhs.createTime
    }
  }
}

extension Dialog: CustomDebugStringConvertible {
  var debugDescription: String {
    let memberNames = members.map { $0.name }.joined(separator: "-")
    return "Dialog(members: \(memberNames)"
  }
}
