import XCTest
@testable import WeChat_SwiftUI

final class UserTests: XCTestCase {
  func test_equatable() {
    XCTAssertEqual(User.template1, User.template1)
    XCTAssertNotEqual(User.template1, User.template2)
  }

  func test_description() {
    XCTAssertNotEqual("", User.template1.debugDescription)
  }

  func test_jsonParsing() {
    let json = """
      {
      "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
      "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
      "name": "LeBron James",
      "wechat_id": "lebron_james",
      "gender": "male",
      "region": "USA",
      "whats_up": "Hello, I'm LeBron James!"
      }
      """

    let user: User? = tryDecode(json)

    XCTAssertEqual("4d0914d5-b04c-43f1-b37f-b2bb8d177951", user?.id)
    XCTAssertEqual("https://cdn.nba.com/headshots/nba/latest/260x190/2544.png", user?.avatar)
    XCTAssertEqual("LeBron James", user?.name)
    XCTAssertEqual("lebron_james", user?.wechatId)
    XCTAssertEqual(.male, user?.gender)
    XCTAssertEqual("USA", user?.region)
    XCTAssertEqual("Hello, I'm LeBron James!", user?.whatsUp)
  }

  func test_index() {
    let account = User.template1
    XCTAssertEqual(account?.index, "J")
  }

  func test_match() {
    let account = User.template1!

    XCTAssertTrue(account.match("M"))
    XCTAssertTrue(account.match("m"))
    XCTAssertFalse(account.match("e"))
  }

  func test_genderImage() {
    XCTAssertEqual(User.Gender.male.iconName, "icons_filled_colorful_male")
    XCTAssertEqual(User.Gender.female.iconName, "icons_filled_colorful_female")
    XCTAssertEqual(User.Gender.unknown.iconName, nil)
  }

  func test_genderDescription() {
    XCTAssertEqual(User.Gender.male.description, Strings.general_male())
    XCTAssertEqual(User.Gender.female.description, Strings.general_female())
  }
}
