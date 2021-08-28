import XCTest
@testable import WeChat_SwiftUI

final class DialogTests: XCTestCase {

  func test_equatable() {
    XCTAssertEqual(Dialog.template1, Dialog.template1)
    XCTAssertNotEqual(Dialog.template1, Dialog.empty)
  }

  func test_description() {
    XCTAssertNotEqual("", Dialog.template1.debugDescription)
  }

  func test_jsonParsing() {
    let json = """
      {
        "id": "55b6cda0-f563-4eb8-88f9-28ff22a53cf7",
        "name": "SwiftUI",
        "members": [
          {
            "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
            "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
            "name": "Ja Morant"
          },
          {
            "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
            "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
            "name": "LeBron James"
          }
        ],
        "messages": [
          {
            "id": "d6a696da-2c7a-4d27-87e3-6f63fd3e597f",
            "text": "hello world",
            "sender": {
              "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
              "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
              "name": "Ja Morant"
            },
            "createTime": "2021-07-14T09:54:22Z",
            "status": "sent"
          }
        ],
        "isSavedToServer": true,
        "createTime": "2021-07-14T09:54:22Z"
      }
      """

    let dialog: Dialog? = tryDecode(json)

    XCTAssertEqual(dialog?.id, "55b6cda0-f563-4eb8-88f9-28ff22a53cf7")
    XCTAssertEqual(dialog?.name, "SwiftUI")
    XCTAssertEqual(dialog?.members.count, 2)
    XCTAssertEqual(dialog?.messages.count, 1)
    XCTAssertEqual(dialog?.createTime, ISO8601DateFormatter().date(from: "2021-07-14T09:54:22Z"))
  }

  func test_insertMessage_appended() {
    let (m1, m2, m3) = sortedMessages()
    var dialog = Dialog(members: [.template1, .template2], messages: [m1, m2])

    dialog = dialog.insert(m3)
    XCTAssertEqual(dialog.messages, [m1, m2, m3])
  }

  func test_insertMessage_inserted() {
    let (m1, m2, m3) = sortedMessages()
    var dialog = Dialog(members: [.template1, .template2], messages: [m1, m3])

    dialog = dialog.insert(m2)

    XCTAssertEqual(dialog.messages, [m1, m2, m3])
  }

  func test_insertMessage_ignoreDuplicated() {
    var dialog: Dialog = .empty
    let message: Message = .textTemplate

    dialog = dialog.insert(message)
    XCTAssertEqual(1, dialog.messages.count)

    dialog = dialog.insert(message)
    XCTAssertEqual(1, dialog.messages.count)
  }

  func test_comparable() {
    let d1 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      messages: [],
      isSavedToServer: false,
      createTime: Date()
    )
    let d2 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      messages: [],
      isSavedToServer: false,
      createTime: Date()
    )
    XCTAssertTrue(d1 > d2)

    let d3 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      messages: [],
      isSavedToServer: false,
      createTime: Date()
    )
    let d4 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      messages: [],
      isSavedToServer: false,
      createTime: Date().addingTimeInterval(10)
    )
    XCTAssertTrue(d3 > d4)
  }

  func test_isIndividual() {
    var dialog = Dialog(members: [.template1])
    XCTAssertFalse(dialog.isIndividual)

    dialog = Dialog(members: [.template1, .template2])
    XCTAssertTrue(dialog.isIndividual)

    let member = Dialog.Member(id: generateUUID(), name: "Lebron", avatar: nil)
    dialog = Dialog(members: [.template1, .template2, member])
    XCTAssertFalse(dialog.isIndividual)
  }

  func test_individualChatMember() {
    withEnvironment(currentUser: .template) {
      var dialog = Dialog(members: [.template1])
      XCTAssertNil(dialog.individualChatMember)

      dialog = Dialog(members: [.currentUser!, .template2])
      XCTAssertEqual(dialog.individualChatMember, .template2)

      let member = Dialog.Member(id: generateUUID(), name: "Lebron", avatar: nil)
      dialog = Dialog(members: [.template1, .template2, member])
      XCTAssertNil(dialog.individualChatMember)
    }
  }
}

// MARK: - Helper Methods
private extension DialogTests {
  func sortedMessages() -> (Message, Message, Message) {
    let now = Date()
    let m1 = Message(text: "1", createTime: now)
    let m2 = Message(text: "2", createTime: now.addingTimeInterval(10))
    let m3 = Message(text: "3", createTime: now.addingTimeInterval(20))
    return (m1, m2, m3)
  }
}
