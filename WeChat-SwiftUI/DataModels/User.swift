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

extension User {
  enum Gender: String, Codable {
    case male
    case female

    var iconName: String {
      switch self {
      case .male:
        return "icons_filled_colorful_male"
      case .female:
        return "icons_filled_colorful_female"
      }
    }
  }
}

extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }
}

extension User: CustomDebugStringConvertible {
  var debugDescription: String {
    "User(id: \(id), name: \"\(name)\")"
  }
}

extension User: ContactType {
  var index: String {
    String(name.first ?? Character("")).uppercased()
  }

  func match(_ query: String) -> Bool {
    if query.isEmpty {
      return true
    }
    return name.lowercased().contains(query.lowercased())
  }
}

// MARK: - Getters
extension User {
  var isMale: Bool {
    gender == .male
  }
}
