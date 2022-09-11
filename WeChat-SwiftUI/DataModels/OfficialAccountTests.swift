import XCTest
@testable import WeChat_SwiftUI

// swiftlint:disable line_length
final class OfficialAccountTests: XCTestCase {

  func test_equatable() {
    XCTAssertEqual(OfficialAccount.template1, OfficialAccount.template1)
    XCTAssertNotEqual(OfficialAccount.template1, OfficialAccount.template2)
  }

  func test_description() {
    XCTAssertNotEqual("", OfficialAccount.template1.debugDescription)
  }

  func test_jsonParsing() {
    let json = """
      {
      "id": "93209b2a-f4d2-43b9-b173-228c417b1a8e",
      "avatar": "https://raw.githubusercontent.com/Lebron1992/WeChat-SwiftUI-Database/main/images/kejimeixue.jpeg",
      "name": "科技美学",
      "pinyin": "kejimeixue"
      }
      """

    let account: OfficialAccount? = tryDecode(json)

    XCTAssertEqual("93209b2a-f4d2-43b9-b173-228c417b1a8e", account?.id)
    XCTAssertEqual("https://raw.githubusercontent.com/Lebron1992/WeChat-SwiftUI-Database/main/images/kejimeixue.jpeg", account?.avatar)
    XCTAssertEqual("科技美学", account?.name)
    XCTAssertEqual("kejimeixue", account?.pinyin)
  }

  func test_index() {
    let account = OfficialAccount.template1
    XCTAssertEqual(account?.index, "G")
  }

  func test_match() {
    let account = OfficialAccount.template1!

    XCTAssertTrue(account.match("广"))
    XCTAssertFalse(account.match("北"))

    XCTAssertTrue(account.match("g"))
    XCTAssertTrue(account.match("G"))
    XCTAssertFalse(account.match("e"))
  }
}
