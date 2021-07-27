import Foundation

struct Dialog: Decodable, Identifiable {
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
