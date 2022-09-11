import XCTest
@testable import WeChat_SwiftUI

final class DialogMessagesTests: XCTestCase, MessagesDataSource {

  func test_equatable() {
    let id = generateUUID()
    let d1 = DialogMessages(dialogId: id, messages: [.textTemplate1])
    let d2 = DialogMessages(dialogId: id, messages: [.textTemplate2])
    let d3 = DialogMessages(dialogId: generateUUID(), messages: [.textTemplate1])
    XCTAssertEqual(d1, d1)
    XCTAssertEqual(d1, d2)
    XCTAssertNotEqual(d1, d3)
  }

  func test_setMessages() {
    let (m1, m2, m3) = sortedMessages()
    var dm = DialogMessages(dialogId: generateUUID(), messages: [])

    dm.setMessages([m1, m2])
    XCTAssertEqual([m1, m2], dm.messages)

    dm.setMessages([m3])
    XCTAssertEqual([m3], dm.messages)
  }

  func test_insertedMessage_insert() {
    let (m1, m2, m3) = sortedMessages()
    var dm = DialogMessages(dialogId: generateUUID(), messages: [m1, m3])
    dm.insertedMessage(m2)
    XCTAssertEqual([m1, m2, m3], dm.messages)
  }

  func test_insertedMessage_append() {
    let (m1, m2, m3) = sortedMessages()
    var dm = DialogMessages(dialogId: generateUUID(), messages: [m1, m2])
    dm.insertedMessage(m3)
    XCTAssertEqual([m1, m2, m3], dm.messages)
  }

  func test_removedMessage() {
    let (m1, m2, m3) = sortedMessages()
    var dm = DialogMessages(dialogId: generateUUID(), messages: [m1, m2, m3])
    dm.removedMessage(m3)
    XCTAssertEqual([m1, m2], dm.messages)
  }

  func test_updatedStatusForMessage() {
    let (m1, _, _) = sortedMessages()
    var dm = DialogMessages(dialogId: generateUUID(), messages: [m1])
    XCTAssertEqual(.idle, dm.messages.element(matching: m1).status)
    dm.updatedStatus(.sending, for: m1)
    XCTAssertEqual(.sending, dm.messages.element(matching: m1).status)
  }
}
