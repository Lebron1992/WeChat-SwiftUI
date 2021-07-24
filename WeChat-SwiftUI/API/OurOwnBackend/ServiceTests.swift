import XCTest
@testable import WeChat_SwiftUI

final class ServiceTests: XCTestCase {

  func test_defaults() {
    XCTAssertTrue(Service().serverConfig == ServerConfig.production)
    XCTAssertNil(Service().oauthToken)
  }

  func test_equals() {
    let s1 = Service()
    let s2 = Service(serverConfig: ServerConfig.staging)
    let s3 = Service(oauthToken: OauthToken(token: "deadbeef"))

    XCTAssertTrue(s1 == s1)
    XCTAssertTrue(s2 == s2)
    XCTAssertTrue(s3 == s3)

    XCTAssertFalse(s1 == s2)
    XCTAssertFalse(s1 == s3)

    XCTAssertFalse(s2 == s3)
  }

  func test_login() {
    let loggedOut = Service()
    let loggedIn = loggedOut.login(OauthToken(token: "deadbeef"))

    XCTAssertTrue(loggedIn == Service(oauthToken: OauthToken(token: "deadbeef")))
  }

  func test_logout() {
    let loggedIn = Service(oauthToken: OauthToken(token: "deadbeef"))
    let loggedOut = loggedIn.logout()

    XCTAssertTrue(loggedOut == Service())
  }
}
