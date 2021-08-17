struct OfficialAccount: Decodable, Equatable {
  let id: String
  let avatar: String
  let name: String
  let pinyin: String

  enum CodingKeys: String, CodingKey {
    case id
    case avatar
    case name
    case pinyin
  }
}

extension OfficialAccount: CustomDebugStringConvertible {
  var debugDescription: String {
    "OfficialAccount(id: \(id), name: \"\(name)\")"
  }
}

extension OfficialAccount: ContactType {
  var index: String {
    String(pinyin.first ?? Character("")).uppercased()
  }

  func match(_ query: String) -> Bool {
    let q = query.lowercased()
    return name.lowercased().contains(q) ||
      pinyin.lowercased().contains(q)
  }
}
