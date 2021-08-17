import XCTest
@testable import WeChat_SwiftUI

final class ExpressionStickerTests: XCTestCase {

  func test_equals() {
    XCTAssertEqual(ExpressionSticker.awesome, ExpressionSticker.awesome)
    XCTAssertNotEqual(ExpressionSticker.awesome, ExpressionSticker.letmesee)
  }

  func test_desciptionForCurrentLanguage() {
    withEnvironment(language: .en) {
      XCTAssertEqual(
        ExpressionSticker.awesome.desciptionForCurrentLanguage(),
        ExpressionSticker.awesome.desc.en
      )
    }

    withEnvironment(language: .zh) {
      XCTAssertEqual(
        ExpressionSticker.awesome.desciptionForCurrentLanguage(),
        ExpressionSticker.awesome.desc.zh
      )
    }
  }
}
