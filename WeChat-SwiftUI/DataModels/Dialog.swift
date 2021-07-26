import Foundation

struct Dialog: Decodable {
  let id: String
  let name: String?
  let members: [Member]
  let messages: [Message]
  let createTime: Date
  let lastMessageText: String?
  let lastMessageTime: Date?
}

extension Dialog {
  struct Member: Decodable {
    let id: String
    let name: String
    let avatar: String?
    let joinTime: Date
  }
}

extension Dialog: Equatable {
  static func == (lhs: Dialog, rhs: Dialog) -> Bool {
    lhs.id == rhs.id
  }
}

extension Dialog: CustomDebugStringConvertible {
  var debugDescription: String {
    let memberNames = members.map { $0.name }.joined(separator: "-")
    return "Dialog(members: \(memberNames)"
  }
}
