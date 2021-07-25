import XCTest
@testable import WeChat_SwiftUI

final class ExpressionStickerTests: XCTestCase {

  func test_equals() {
    XCTAssertEqual(ExpressionSticker.awesome, ExpressionSticker.awesome)
    XCTAssertNotEqual(ExpressionSticker.awesome, ExpressionSticker.letmesee)
  }

  func test_desciptionForCurrentLanguage() {
    AppEnvironment.pushEnvironment(language: .en)
    XCTAssertEqual(
      ExpressionSticker.awesome.desciptionForCurrentLanguage(),
      ExpressionSticker.awesome.desc.en
    )
    AppEnvironment.popEnvironment()

    AppEnvironment.pushEnvironment(language: .zh)
    XCTAssertEqual(
      ExpressionSticker.awesome.desciptionForCurrentLanguage(),
      ExpressionSticker.awesome.desc.zh
    )
    AppEnvironment.popEnvironment()
  }
}
