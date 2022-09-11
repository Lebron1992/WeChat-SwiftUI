import XCTest
@testable import WeChat_SwiftUI

final class DialogTests: XCTestCase, MessagesDataSource {

  func test_equatable() {
    XCTAssertEqual(Dialog.template1, Dialog.template1)
    XCTAssertNotEqual(Dialog.template1, Dialog.template2)
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
        "lastMessage": {
            "id": "d6a696da-2c7a-4d27-87e3-6f63fd3e597f",
            "text": "hello world",
            "sender": {
              "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
              "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
              "name": "Ja Morant"
            },
            "createTime": "2021-07-14T09:54:22Z",
            "status": "sent"
          },
        "createTime": "2021-07-14T09:54:22Z"
      }
      """

    let dialog: Dialog? = tryDecode(json)

    XCTAssertEqual(dialog?.id, "55b6cda0-f563-4eb8-88f9-28ff22a53cf7")
    XCTAssertEqual(dialog?.name, "SwiftUI")
    XCTAssertEqual(dialog?.members.count, 2)
    XCTAssertNotNil(dialog?.lastMessage)
    XCTAssertEqual(dialog?.createTime, ISO8601DateFormatter().date(from: "2021-07-14T09:54:22Z"))
  }

  func test_updatedLastMessage_lastMessageIsNil() {
    var dialog = Dialog(members: [.template1, .template2], lastMessage: nil)
    XCTAssertNil(dialog.lastMessage)

    dialog = dialog.updatedLastMessage(.textTemplate1)
    XCTAssertEqual(dialog.lastMessage, .textTemplate1)
  }

  func test_updatedLastMessage_lastMessageUpdated() {
    let (m1, m2, _) = sortedMessages()

    var dialog = Dialog(members: [.template1, .template2], lastMessage: m1)
    XCTAssertEqual(dialog.lastMessage, m1)

    dialog = dialog.updatedLastMessage(m2)
    XCTAssertEqual(dialog.lastMessage, m2)
  }

  func test_updatedLastMessage_ignored() {
    let (m1, m2, _) = sortedMessages()

    var dialog = Dialog(members: [.template1, .template2], lastMessage: m2)
    XCTAssertEqual(dialog.lastMessage, m2)

    dialog = dialog.updatedLastMessage(m1)
    XCTAssertEqual(dialog.lastMessage, m2)
  }

  func test_comparable() {
    var d1 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      lastMessage: .init(text: "", createTime: Date()),
      createTime: Date()
    )
    var d2 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      lastMessage: .init(text: "", createTime: Date().addingTimeInterval(10)),
      createTime: Date()
    )
    XCTAssertTrue(d2 < d1)

    d1 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      lastMessage: .init(text: "", createTime: Date()),
      createTime: Date()
    )
    d2 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      lastMessage: nil,
      createTime: Date().addingTimeInterval(10)
    )
    XCTAssertTrue(d2 < d1)

    d1 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      lastMessage: nil,
      createTime: Date()
    )
    d2 = Dialog(
      id: generateUUID(),
      name: "",
      members: [],
      lastMessage: nil,
      createTime: Date().addingTimeInterval(10)
    )
    XCTAssertTrue(d2 < d1)
  }

  func test_lastMessageText_textMessage() {
    let message = Message(text: "hello world")
    let dialog = Dialog(members: [.template1, .template2], lastMessage: message)
    XCTAssertEqual(dialog.lastMessageText, message.text)
  }

  func test_lastMessageText_imageMessage() {
    let message = Message(image: .urlTemplate)
    let dialog = Dialog(members: [.template1, .template2], lastMessage: message)
    XCTAssertEqual(dialog.lastMessageText, "[\(Strings.general_photo())]")
  }

  func test_lastMessageText_videoMessage() {
    // TODO: will test when we implement video message
  }

  func test_lastMessageTime() {
    let formatForDate: (Date) -> String = { time in
      Calendar.current.isDateInToday(time) ? "HH:mm" : "yyyy/MM/dd"
    }
    let formatter = DateFormatter()

    // today
    let time1 = Date()
    let message1 = Message(text: "hello", createTime: time1)
    let dialog1 = Dialog(members: [.template1, .template2], lastMessage: message1)

    formatter.dateFormat = formatForDate(time1)
    XCTAssertEqual(dialog1.lastMessageTimeString, formatter.string(from: time1))

    // yesterday
    let time2 = Date().addingTimeInterval(-60 * 60 * 24)
    let message2 = Message(text: "world", createTime: time2)
    let dialog2 = Dialog(members: [.template1, .template2], lastMessage: message2)

    formatter.dateFormat = formatForDate(time2)
    XCTAssertEqual(dialog2.lastMessageTimeString, formatter.string(from: time2))
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
    withEnvironment(currentUser: .template1) {
      var dialog = Dialog(members: [.template1])
      XCTAssertNil(dialog.individualChatMember)

      dialog = Dialog(members: [.currentUser!, .template2])
      XCTAssertEqual(dialog.individualChatMember, .template2)

      let member = Dialog.Member(id: generateUUID(), name: "Lebron", avatar: nil)
      dialog = Dialog(members: [.template1, .template2, member])
      XCTAssertNil(dialog.individualChatMember)
    }
  }

  func test_isSelfParticipated() {
    withEnvironment(currentUser: .template1) {
      let d1 = Dialog(members: [.currentUser!, .template1])
      let d2 = Dialog(members: [.template2, .template3])
      XCTAssertTrue(d1.isSelfParticipated)
      XCTAssertFalse(d2.isSelfParticipated)
    }
  }
}
