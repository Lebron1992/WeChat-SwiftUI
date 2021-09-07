import Foundation

struct Message: Codable, Identifiable, Equatable {
  let id: String
  let text: String?
  let image: Image?
  let videoUrl: String?
  let sender: MessageSender
  let createTime: Date
  let status: Status

  init(
    id: String,
    text: String?,
    image: Image?,
    videoUrl: String?,
    sender: MessageSender,
    createTime: Date,
    status: Status
  ) {
    self.id = id
    self.text = text
    self.image = image
    self.videoUrl = videoUrl
    self.sender = sender
    self.createTime = createTime
    self.status = status
  }

  init(
    text: String,
    createTime: Date = Date(),
    status: Status = .idle
  ) {
    self.init(
      id: generateUUID(),
      text: text,
      image: nil,
      videoUrl: nil,
      sender: .currentUser ?? .anonymity,
      createTime: createTime,
      status: status
    )
  }

  init(
    image: Image,
    createTime: Date = Date(),
    status: Status = .idle
  ) {
    self.init(
      id: generateUUID(),
      text: nil,
      image: image,
      videoUrl: nil,
      sender: .currentUser ?? .anonymity,
      createTime: createTime,
      status: status
    )
  }
}

extension Message {
  struct MessageSender: Codable, Equatable {
    let id: String
    let name: String
    let avatar: String

    static var currentUser: Self? {
      guard let user = AppEnvironment.current.currentUser else {
        return nil
      }
      return .init(id: user.id, name: user.name, avatar: user.avatar)
    }

    static var anonymity: Self {
      .init(id: generateUUID(), name: "Anonymous", avatar: "")
    }
  }
}

extension Message {
  enum Status: String, Codable {
    case idle
    case sending
    case sent
  }
}

// MARK: - Getters
extension Message {
  var isTextMsg: Bool {
    text != nil
  }

  var isImageMsg: Bool {
    image != nil
  }

  var isVideoMsg: Bool {
    videoUrl != nil
  }

  var isOutgoingMsg: Bool {
    sender.id == AppEnvironment.current.currentUser?.id
  }

  var isSending: Bool {
    status == .sending
  }

  var isSent: Bool {
    status == .sent
  }
}

extension Message: Comparable {
  static func < (lhs: Message, rhs: Message) -> Bool {
    lhs.createTime < rhs.createTime
  }
}

extension Message: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Message: CustomDebugStringConvertible {
  var debugDescription: String {
    if isTextMsg {
      return "Message(sender: \(sender.name), text: \"\(text!)\")"
    }

    if isImageMsg {
      return "Message(sender: \(sender.name), image: \"\(image!)\")"
    }

    if isVideoMsg {
      return "Message(sender: \(sender.name), videoUrl: \"\(videoUrl!)\")"
    }

    return ""
  }
}
