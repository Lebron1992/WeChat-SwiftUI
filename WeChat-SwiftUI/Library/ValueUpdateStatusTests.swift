import XCTest
@testable import WeChat_SwiftUI

final class ValueUpdateStatusTests: XCTestCase {

  func test_equatable() {
    var v1: ValueUpdateStatus<String> = .idle
    var v2: ValueUpdateStatus<String> = .idle
    XCTAssertEqual(v1, v2)

    v1 = .updating
    v2 = .updating
    XCTAssertEqual(v1, v2)

    v1 = .finished("Hello")
    v2 = .finished("Hello")
    XCTAssertEqual(v1, v2)

    v1 = .finished("Hello")
    v2 = .finished("World")
    XCTAssertNotEqual(v1, v2)

    let e1 = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Hello"])
    let e2 = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "World"])

    v1 = .failed(e1)
    v2 = .failed(e1)
    XCTAssertEqual(v1, v2)

    v1 = .failed(e1)
    v2 = .failed(e2)
    XCTAssertNotEqual(v1, v2)

    v1 = .idle
    v2 = .updating
    XCTAssertNotEqual(v1, v2)

    v1 = .updating
    v2 = .finished("Hello")
    XCTAssertNotEqual(v1, v2)
  }

  func test_value() {
    var v: ValueUpdateStatus<String> = .idle
    XCTAssertNil(v.value)

    v = .updating
    XCTAssertNil(v.value)

    v = .finished("Hello")
    XCTAssertEqual(v.value, "Hello")

    let e = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Hello"])

    v = .failed(e)
    XCTAssertNil(v.value)
  }

  func test_error() {
    var v: ValueUpdateStatus<String> = .idle
    XCTAssertNil(v.error)

    v = .updating
    XCTAssertNil(v.error)

    v = .finished("Hello")
    XCTAssertNil(v.error)

    let e = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Hello"])

    v = .failed(e)
    XCTAssertNotNil(v.error)
  }
}
