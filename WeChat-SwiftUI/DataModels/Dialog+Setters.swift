import Foundation

extension Dialog {
  func setMessages(_ messages: [Message]) -> Dialog {
    Dialog(
      id: id,
      name: name,
      members: members,
      messages: messages,
      isSavedToServer: isSavedToServer,
      createTime: createTime
    )
  }

  func setIsSavedToServer(_ isSavedToServer: Bool) -> Dialog {
    Dialog(
      id: id,
      name: name,
      members: members,
      messages: messages,
      isSavedToServer: isSavedToServer,
      createTime: createTime
    )
  }

  func setMessage(_ message: Message, at index: Int) -> Dialog {
    var newMessages = messages
    newMessages[index] = message
    return setMessages(newMessages)
  }
}
