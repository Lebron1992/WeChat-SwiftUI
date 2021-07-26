import XCTest
@testable import WeChat_SwiftUI

final class MessageTests: XCTestCase {
  func test_equatable() {
    XCTAssertEqual(Message.textTemplate, Message.textTemplate)
    XCTAssertNotEqual(Message.textTemplate, Message.textTemplate2)
  }

  func test_description() {
    XCTAssertNotEqual("", Message.textTemplate.debugDescription)
  }

  func test_jsonParsing() {
    let json = """
      {
      "id": "d6a696da-2c7a-4d27-87e3-6f63fd3e597f",
      "text": "hello world",
      "sender": {
        "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
        "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
        "name": "Ja Morant"
      },
      "createTime": 1626256462
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

  func test_isTextMsg() {
    XCTAssertTrue(Message.textTemplate.isTextMsg)
    XCTAssertFalse(Message.imageTemplate2.isTextMsg)
    XCTAssertFalse(Message.videoTemplate3.isTextMsg)
  }

  func test_isImageMsg() {
    XCTAssertFalse(Message.textTemplate.isImageMsg)
    XCTAssertTrue(Message.imageTemplate2.isImageMsg)
    XCTAssertFalse(Message.videoTemplate3.isImageMsg)
  }

  func test_isVideoMsg() {
    XCTAssertFalse(Message.textTemplate.isVideoMsg)
    XCTAssertFalse(Message.imageTemplate2.isVideoMsg)
    XCTAssertTrue(Message.videoTemplate3.isVideoMsg)
  }
}
