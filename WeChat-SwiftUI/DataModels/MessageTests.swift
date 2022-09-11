import XCTest
@testable import WeChat_SwiftUI

final class MessageTests: XCTestCase {
  func test_equatable() {
    XCTAssertEqual(Message.textTemplate1, Message.textTemplate1)
    XCTAssertNotEqual(Message.textTemplate1, Message.textTemplate2)
  }

  func test_description() {
    XCTAssertNotEqual("", Message.textTemplate1.debugDescription)
  }

  func test_jsonParsingTextMessage() {
    let json = """
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
      """

    let message: Message? = tryDecode(json)

    XCTAssertEqual("d6a696da-2c7a-4d27-87e3-6f63fd3e597f", message?.id)
    XCTAssertEqual("hello world", message?.text)
    XCTAssertEqual("112ec2a2-68d3-4949-9ce9-82ec80db9c60", message?.sender.id)
    XCTAssertEqual("https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png", message?.sender.avatar)
    XCTAssertEqual("Ja Morant", message?.sender.name)
    XCTAssertEqual(Date(timeIntervalSince1970: 1626256462), message?.createTime)
  }

  func test_jsonParsingImageMessage() {
    let json = """
      {
      "id": "d6a696da-2c7a-4d27-87e3-6f63fd3e597f",
      "image": {
        "urlImage": {
          "url": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
          "width": 260,
          "height": 190
        }
      },
      "sender": {
        "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
        "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
        "name": "Ja Morant"
      },
      "createTime": "2021-07-14T09:54:22Z",
      "status": "sent"
      }
      """

    let message: Message? = tryDecode(json)

    XCTAssertEqual("d6a696da-2c7a-4d27-87e3-6f63fd3e597f", message?.id)
    XCTAssertEqual("https://cdn.nba.com/headshots/nba/latest/260x190/2544.png", message?.image?.url)
    XCTAssertEqual(.init(width: 260, height: 190), message?.image?.size)
    XCTAssertEqual("112ec2a2-68d3-4949-9ce9-82ec80db9c60", message?.sender.id)
    XCTAssertEqual("https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png", message?.sender.avatar)
    XCTAssertEqual("Ja Morant", message?.sender.name)
    XCTAssertEqual(Date(timeIntervalSince1970: 1626256462), message?.createTime)
  }

  func test_isTextMsg() {
    XCTAssertTrue(Message.textTemplate1.isTextMsg)
    XCTAssertFalse(Message.urlImageTemplate.isTextMsg)
    XCTAssertFalse(Message.videoTemplate3.isTextMsg)
  }

  func test_isImageMsg() {
    XCTAssertFalse(Message.textTemplate1.isImageMsg)
    XCTAssertTrue(Message.urlImageTemplate.isImageMsg)
    XCTAssertFalse(Message.videoTemplate3.isImageMsg)
  }

  func test_isVideoMsg() {
    XCTAssertFalse(Message.textTemplate1.isVideoMsg)
    XCTAssertFalse(Message.urlImageTemplate.isVideoMsg)
    XCTAssertTrue(Message.videoTemplate3.isVideoMsg)
  }

  func test_isSending() {
    var message = Message(text: "hello", status: .idle)
    XCTAssertFalse(message.isSending)

    message = Message(text: "hello", status: .sending)
    XCTAssertTrue(message.isSending)

    message = Message(text: "hello", status: .sent)
    XCTAssertFalse(message.isSending)
  }

  func test_isSent() {
    var message = Message(text: "hello", status: .idle)
    XCTAssertFalse(message.isSent)

    message = Message(text: "hello", status: .sending)
    XCTAssertFalse(message.isSent)

    message = Message(text: "hello", status: .sent)
    XCTAssertTrue(message.isSent)
  }
}
