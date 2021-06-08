import XCTest
@testable import WeChat_SwiftUI

final class ServiceTypeTests: XCTestCase {

  private var serviceWithToken: ServiceType!
  private var serviceWithoutToken: ServiceType!

  override func setUp() {
    super.setUp()
    serviceWithToken = Service(oauthToken: OauthToken(token: "cafebeef"))
    serviceWithoutToken = Service()
  }

  override func tearDown() {
    super.tearDown()
    serviceWithToken = nil
    serviceWithoutToken = nil
  }

  func test_preparedRequest() {
    let url = URL(string: "http://api.wechat.com/v1/test")!
    let request = serviceWithToken.preparedRequest(forRequest: .init(url: url), query: ["extra": "1"])

    XCTAssertEqual(
      "http://api.wechat.com/v1/test?extra=1",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      ["Authorization": "token cafebeef"],
      request.allHTTPHeaderFields!
    )
  }

  func test_preparedURL() {
    let url = URL(string: "http://api.wechat.com/v1/test")!
    let request = serviceWithToken.preparedRequest(forURL: url, query: ["extra": "1"])

    XCTAssertEqual(
      "http://api.wechat.com/v1/test?extra=1",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      ["Authorization": "token cafebeef"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("GET", request.httpMethod)
  }

  func test_preparedDeleteURL() {
    let url = URL(string: "http://api.wechat.com/v1/test")!
    let request = serviceWithToken.preparedRequest(forURL: url, method: .DELETE, query: ["extra": "1"])

    XCTAssertEqual(
      "http://api.wechat.com/v1/test?extra=1",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      ["Authorization": "token cafebeef"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("DELETE", request.httpMethod)
  }

  func test_preparedPostURL() {
    let url = URL(string: "http://api.wechat.com/v1/test")!
    let request = serviceWithToken.preparedRequest(forURL: url, method: .POST, query: ["extra": "1"])

    XCTAssertEqual(
      "http://api.wechat.com/v1/test?",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      ["Authorization": "token cafebeef", "Content-Type": "application/json; charset=utf-8"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.httpMethod)
    XCTAssertEqual(
      "{\"extra\":\"1\"}",
      String(data: request.httpBody ?? Data(), encoding: .utf8)
    )
  }

  func test_preparedPostURLWithBody() {
    let url = URL(string: "http://api.wechat.com/v1/test")!
    var baseRequest = URLRequest(url: url)
    let body = "test".data(using: .utf8, allowLossyConversion: false)
    baseRequest.httpBody = body
    baseRequest.httpMethod = "POST"
    let request = serviceWithToken.preparedRequest(forRequest: baseRequest, query: ["extra": "1"])

    XCTAssertEqual(
      "http://api.wechat.com/v1/test?",
      request.url?.absoluteString
    )
    XCTAssertEqual(
      ["Authorization": "token cafebeef"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.httpMethod)
    XCTAssertEqual(body, request.httpBody, "Body remains unchanged")
  }
}
