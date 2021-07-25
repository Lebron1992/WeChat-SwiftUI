import XCTest
@testable import WeChat_SwiftUI

final class LocalizedStringTests: XCTestCase {
  private let enMockBundle = MockBundle(lang: "en")
  private let zhMockBundle = MockBundle(lang: "zh-Hans")

  func test_localizingInZh() {
    withEnvironment(language: .zh) {
      // correct key
      XCTAssertEqual("zh_world", localizedString(key: "hello", bundle: zhMockBundle))

      // wrong key, return the given default value
      XCTAssertEqual("Hello", localizedString(key: "hello_", defaultValue: "Hello", bundle: zhMockBundle))

      // wrong key, return default value
      XCTAssertEqual("", localizedString(key: "hello_", bundle: zhMockBundle))

      // substitutions
      XCTAssertEqual(
        "zh_hello A B",
        localizedString(key: "hello_format", substitutions: ["a": "A", "b": "B"], bundle: zhMockBundle)
      )

      XCTAssertEqual(
        "",
        localizedString(key: "echo", bundle: zhMockBundle),
        "When key/value are equal we should return an empty string"
      )
    }
  }

  func test_localizedStringWithCount() {
    withEnvironment(language: .en) {
      XCTAssertEqual(localizedString(key: "test_count", count: 0, bundle: enMockBundle), "zero")

      XCTAssertEqual(localizedString(key: "test_count", count: 1, bundle: enMockBundle), "one")

      XCTAssertEqual(localizedString(key: "test_count", count: 2, bundle: enMockBundle), "two")

      XCTAssertEqual(
        localizedString(key: "test_count", count: 3, substitutions: ["the_count": "3"], bundle: enMockBundle),
        "3 few"
      )

      XCTAssertEqual(
        localizedString(key: "test_count", count: 4, substitutions: ["the_count": "4"], bundle: enMockBundle),
        "4 few"
      )

      XCTAssertEqual(
        localizedString(key: "test_count", count: 5, substitutions: ["the_count": "5"], bundle: enMockBundle),
        "5 few"
      )

      XCTAssertEqual(
        localizedString(key: "test_count", count: 6, substitutions: ["the_count": "6"], bundle: enMockBundle),
        "6 many"
      )
    }
  }

  func test_missingKeyWithCount() {
    withEnvironment(language: .en) {
      XCTAssertEqual(
        "10 backers",
        localizedString(
          key: "missing.key",
          defaultValue: "%{count} backers",
          count: 10,
          substitutions: ["count": "10"],
          bundle: enMockBundle
        )
      )
    }
  }
}
