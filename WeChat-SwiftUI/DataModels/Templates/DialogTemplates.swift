import Foundation

private let timeIntervalSince1970 = 651657993.0

extension Dialog {
    static let template1 = Dialog(
        id: "ee0d9688-c25b-45fa-b484-94e9c13700d6",
        name: "SwiftUI",
        members: [.template1, .template2],
        lastMessage: .textTemplate1,
        createTime: Date(timeIntervalSince1970: timeIntervalSince1970 - 1000)
    )

    static let template2 = Dialog(
        id: "46ea1b2a-327d-4f17-bdb0-220a88e3a9bb",
        name: "Template3",
        members: [.template1, .template3],
        lastMessage: nil,
        createTime: Date()
    )
}

extension Dialog.Member {
    static let template1 = Dialog.Member(
        id: User.template1.id,
        name: User.template1.name,
        avatar: User.template1.avatar
    )

  static let template2 = Dialog.Member(
      id: User.template2.id,
      name: User.template2.name,
      avatar: User.template2.avatar
  )

  static let template3 = Dialog.Member(
      id: generateUUID(),
      name: "template3",
      avatar: "https://cdn.nba.com/headshots/nba/latest/260x190/template3.png"
  )
}
