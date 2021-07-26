import Foundation

extension Dialog {
    static let template1 = Dialog(
        id: "ee0d9688-c25b-45fa-b484-94e9c13700d6",
        name: nil,
        members: [.template1, .template2],
        messages: [.textTemplate, .textTemplate2],
        createTime: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 1000),
        lastMessageText: Message.textTemplate2.text,
        lastMessageTime: Message.textTemplate2.createTime
    )

    static let template2 = Dialog(
        id: "46ea1b2a-327d-4f17-bdb0-220a88e3a9bb",
        name: nil,
        members: [],
        messages: [],
        createTime: Date(),
        lastMessageText: nil,
        lastMessageTime: nil
    )
}

extension Dialog.Member {
    static let template1 = Dialog.Member(
        id: User.template.id,
        name: User.template.name,
        avatar: User.template.avatar,
        joinTime: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 1000)
    )

    static let template2 = Dialog.Member(
        id: User.template2.id,
        name: User.template2.name,
        avatar: User.template2.avatar,
        joinTime: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 1000)
    )
}
