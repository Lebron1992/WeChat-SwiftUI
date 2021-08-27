import Foundation

struct Dialog: Codable, Identifiable, Equatable {
  let id: String
  let name: String?
  let members: [Member]
  let messages: [Message]
  let createTime: Date

  init(
    id: String,
    name: String?,
    members: [Member],
    messages: [Message],
    createTime: Date
  ) {
    self.id = id
    self.name = name
    self.members = members
    self.messages = messages
    self.createTime = createTime
  }

  init(members: [Member]) {

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
      messages: [],
      createTime: Date()
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
  func append(_ message: Message) -> Dialog {
    guard messages.contains(message) == false else {
      return self
    }

    var newMessages = messages
    newMessages.append(message)

    return setMessages(newMessages)
  }
}

// MARK: - Getters
extension Dialog {
  var lastMessageText: String? {
    messages.last?.text
  }

  var lastMessageTime: Date? {
    messages.last?.createTime
  }

  var lastMessageTimeString: String? {
    guard let time = lastMessageTime else {
      return nil
    }
    // TODO: test for now
    let formatter = DateFormatter()
    formatter.dateStyle = .short
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
}

extension Dialog: Comparable {
  static func < (lhs: Dialog, rhs: Dialog) -> Bool {
    if let lhsLastTime = lhs.lastMessageTime, let rhsLastTime = rhs.lastMessageTime {
      return lhsLastTime > rhsLastTime
    }
    return lhs.createTime > rhs.createTime
  }
}

extension Dialog: CustomDebugStringConvertible {
  var debugDescription: String {
    let memberNames = members.map { $0.name }.joined(separator: "-")
    return "Dialog(members: \(memberNames)"
  }
}
