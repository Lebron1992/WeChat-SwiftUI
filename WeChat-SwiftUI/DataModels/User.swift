import FirebaseAuth

struct User: Codable, Identifiable, Equatable {
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

  init(
   id: String,
   avatar: String,
   name: String,
   wechatId: String,
   gender: Gender,
   region: String,
   whatsUp: String
  ) {
    self.id = id
    self.avatar = avatar
    self.name = name
    self.wechatId = wechatId
    self.gender = gender
    self.region = region
    self.whatsUp = whatsUp
  }

  init(firUser: FirebaseAuth.User) {
    self.init(
      id: firUser.uid,
      avatar: firUser.photoURL?.absoluteString ?? "",
      name: firUser.displayName ?? "",
      wechatId: "wxid_\(UUID().uuidString.lowercased())",
      gender: .unknown,
      region: "",
      whatsUp: ""
    )
  }
}

extension User {
  enum Gender: String, Codable {
    case male
    case female
    case unknown

    var iconName: String? {
      switch self {
      case .male:
        return "icons_filled_colorful_male"
      case .female:
        return "icons_filled_colorful_female"
      case .unknown:
        return nil
      }
    }

    var description: String {
      switch self {
      case .male:
        return Strings.general_male()
      case .female:
        return Strings.general_female()
      case .unknown:
        return ""
      }
    }
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
