struct User: Codable, Identifiable {
  let id: String
  let avatar: String
  let name: String
  let wechatId: String
  let gender: Gender
  let region: String
  let whatsUp: String

  enum CodingKeys: String, CodingKey {
    case id
    case avatar
    case name
    case wechatId = "wechat_id"
    case gender
    case region
    case whatsUp  = "whats_up"
  }
}

extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }
}

extension User {
  enum Gender: String, Codable {
    case male
    case female
  }
}

extension User: CustomDebugStringConvertible {
  var debugDescription: String {
    "User(id: \(self.id), name: \"\(self.name)\")"
  }
}
