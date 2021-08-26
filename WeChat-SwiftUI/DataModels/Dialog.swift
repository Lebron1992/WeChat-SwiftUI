import Foundation

struct Dialog: Decodable, Identifiable, Equatable {
  let id: String
  let name: String?
  let members: [Member]
  let messages: [Message]
  let createTime: Date
  let lastMessageText: String?
  let lastMessageTime: Date?

  init(
    id: String,
    name: String?,
    members: [Member],
    messages: [Message],
    createTime: Date,
    lastMessageText: String?,
    lastMessageTime: Date?
  ) {
    self.id = id
    self.name = name
    self.members = members
    self.messages = messages
    self.createTime = createTime
    self.lastMessageText = lastMessageText
    self.lastMessageTime = lastMessageTime
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
      createTime: Date(),
      lastMessageText: nil,
      lastMessageTime: nil
    )
  }
}

extension Dialog {
  struct Member: Decodable, Equatable {
    let id: String
    let name: String
    let avatar: String?
    let joinTime: Date

    init(
      id: String,
      name: String,
      avatar: String?,
      joinTime: Date
    ) {
      self.id = id
      self.name = name
      self.avatar = avatar
      self.joinTime = joinTime
    }

    init(user: User) {
      self.id = user.id
      self.name = user.name
      self.avatar = user.avatar
      self.joinTime = Date()
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
  var lastMessageTimeString: String? {
    guard let time = lastMessageTime else {
      return nil
    }
    // TODO: test for now
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: time)
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
