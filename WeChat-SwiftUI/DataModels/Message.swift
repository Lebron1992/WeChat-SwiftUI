import Foundation

struct Message: Decodable, Identifiable, Equatable {
  let id: String
  let text: String?
  let imageUrl: String?
  let videoUrl: String?
  let sender: MessageSender
  let createTime: Date
}

extension Message {
  struct MessageSender: Decodable, Equatable {
    let id: String
    let name: String
    let avatar: String
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
