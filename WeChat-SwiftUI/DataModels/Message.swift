import Foundation

struct Message: Decodable, Identifiable {
  let id: String
  let text: String?
  let imageUrl: String?
  let videoUrl: String?
  let sender: MessageSender
  let created: Date

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id = try values.decode(String.self, forKey: .id)
    text = try values.decodeIfPresent(String.self, forKey: .text)
    imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
    videoUrl = try values.decodeIfPresent(String.self, forKey: .videoUrl)
    sender = try values.decode(MessageSender.self, forKey: .sender)

    let createdInterval = try values.decode(TimeInterval.self, forKey: .created)
    created = Date(timeIntervalSince1970: createdInterval)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case text
    case imageUrl
    case videoUrl
    case sender
    case created
  }
}

extension Message {
  struct MessageSender: Decodable {
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

extension Message: Equatable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    lhs.id == rhs.id
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
