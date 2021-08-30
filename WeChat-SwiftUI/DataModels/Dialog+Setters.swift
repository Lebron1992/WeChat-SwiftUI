import Foundation

extension Dialog {
  func setLastMessage(_ lastMessage: Message) -> Dialog {
    Dialog(
      id: id,
      name: name,
      members: members,
      lastMessage: lastMessage,
      createTime: createTime
    )
  }
}
