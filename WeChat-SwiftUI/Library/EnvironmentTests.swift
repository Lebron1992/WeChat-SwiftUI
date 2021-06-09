import XCTest
@testable import WeChat_SwiftUI

final class EnvironmentTests: XCTestCase {
  func test_defaults() {
    let env = Environment()

    XCTAssertTrue(env.apiService == Service())
    XCTAssertNil(env.currentUser)
    XCTAssertEqual(env.language, Language(languageStrings: Locale.preferredLanguages))
  }
}
