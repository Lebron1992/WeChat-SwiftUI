import Foundation

extension DialogMessages {
  static let template1 = DialogMessages(dialogId: generateUUID(), messages: [.textTemplate])
  static let template2 = DialogMessages(dialogId: generateUUID(), messages: [.textTemplate2])
}
