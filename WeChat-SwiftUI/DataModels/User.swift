struct User: Codable {
  let id: String
}

extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }
}
