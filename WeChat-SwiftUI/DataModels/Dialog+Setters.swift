import Foundation

extension Dialog {
  func setMessages(_ messages: [Message]) -> Dialog {
    Dialog(
      id: id,
      name: name,
      members: members,
      messages: messages,
      createTime: createTime
    )
  }
}
