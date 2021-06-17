struct User: Codable, Identifiable {
  let id: String
  let avatar: String
  let name: String
  let wechat_id: String
  let gender: Gender
  let region: String
  let whats_up: String
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
