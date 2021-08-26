import Foundation

struct Message: Decodable, Identifiable, Equatable {
  let id: String
  let text: String?
  let imageUrl: String?
  let videoUrl: String?
  let sender: MessageSender
  let createTime: Date

  init(
    id: String,
    text: String?,
    imageUrl: String?,
    videoUrl: String?,
    sender: MessageSender,
    createTime: Date
  ) {
    self.id = id
    self.text = text
    self.imageUrl = imageUrl
    self.videoUrl = videoUrl
    self.sender = sender
    self.createTime = createTime
  }

  init(text: String) {
    self.init(
      id: generateUUID(),
      text: text,
      imageUrl: nil,
      videoUrl: nil,
      sender: .currentUser ?? .anonymity,
      createTime: Date()
    )
  }
}

extension Message {
  struct MessageSender: Decodable, Equatable {
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
  var isTextMsg: Bool {
    text != nil
  }

  var isImageMsg: Bool {
    imageUrl != nil
  }

  var isVideoMsg: Bool {
    videoUrl != nil
  }

  var isOutgoingMsg: Bool {
    sender.id == AppEnvironment.current.currentUser?.id
  }
}

extension Message: CustomDebugStringConvertible {
  var debugDescription: String {
    if isTextMsg {
      return "Message(sender: \(sender.name), text: \"\(text!)\")"
    }

    if isImageMsg {
      return "Message(sender: \(sender.name), imageUrl: \"\(imageUrl!)\")"
    }

    if isVideoMsg {
      return "Message(sender: \(sender.name), videoUrl: \"\(videoUrl!)\")"
    }

    return ""
  }
}
