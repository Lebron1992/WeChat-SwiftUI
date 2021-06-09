import XCTest
@testable import WeChat_SwiftUI

final class LanguageTests: XCTestCase {

  func test_initializer() {
    XCTAssertEqual(Language.en, Language(languageString: "En"))
    XCTAssertEqual(Language.zh, Language(languageString: "Zh"))
    XCTAssertEqual(nil, Language(languageString: "AB"))
  }

  func test_languageFromLanguageStrings() {
    XCTAssertEqual(Language.en, Language(languageStrings: ["AB", "EN", "FR"]))
    XCTAssertEqual(Language.zh, Language(languageStrings: ["AB", "BC", "ZH"]))
    XCTAssertEqual(nil, Language(languageStrings: ["AB", "BC", "CD"]))
  }
}
