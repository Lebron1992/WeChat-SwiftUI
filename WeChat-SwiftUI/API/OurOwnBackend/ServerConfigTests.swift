import XCTest
@testable import WeChat_SwiftUI

final class ServerConfigTests: XCTestCase {

  func test_defaults() {
    let s = ServerConfig(
      apiBaseUrl: URL(string: Secrets.Api.Endpoint.production)!
    )
    XCTAssertTrue(s.environment == .production)
  }

  func test_production() {
    let prod = ServerConfig.production
    XCTAssertEqual(prod.apiBaseUrl, URL(string: Secrets.Api.Endpoint.production)!)
    XCTAssertEqual(prod.environment, .production)
  }

  func test_staging() {
    let staging = ServerConfig.staging
    XCTAssertEqual(staging.apiBaseUrl, URL(string: Secrets.Api.Endpoint.staging)!)
    XCTAssertEqual(staging.environment, .staging)
  }

  func test_equals() {
    let prod1: ServerConfigType = ServerConfig(
      apiBaseUrl: URL(string: Secrets.Api.Endpoint.production)!,
      environment: .production
    )
    let prod2: ServerConfigType = ServerConfig(
      apiBaseUrl: URL(string: Secrets.Api.Endpoint.production)!,
      environment: .production
    )

    XCTAssertTrue(prod1 == prod2)

    let staging: ServerConfigType = ServerConfig(
      apiBaseUrl: URL(string: Secrets.Api.Endpoint.staging)!,
      environment: .staging
    )

    XCTAssertFalse(prod1 == staging)
  }
}
