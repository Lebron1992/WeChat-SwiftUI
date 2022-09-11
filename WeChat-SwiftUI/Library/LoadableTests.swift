import XCTest
@testable import WeChat_SwiftUI

private struct Model: Equatable {
  let prop: String
}

private typealias ModelLoadable = Loadable<Model>
private typealias StringLoadable = Loadable<String>

private let model = Model(prop: "hello world")
private let cancelError = NSError(
  domain: NSCocoaErrorDomain,
  code: NSUserCancelledError,
  userInfo: [NSLocalizedDescriptionKey: "Canceled by user"]
)

final class LoadableTests: XCTestCase {

  private let notRequested = ModelLoadable.notRequested
  private let loaded = ModelLoadable.loaded(model)
  private let isLoadingWithValue = ModelLoadable.isLoading(last: model)
  private let isLoadingWithNoValue = ModelLoadable.isLoading(last: nil)
  private let failed = ModelLoadable.failed(cancelError)

  func test_value() {
    XCTAssertNil(notRequested.value)
    XCTAssertEqual(loaded.value, model)
    XCTAssertEqual(isLoadingWithValue.value, model)
    XCTAssertNil(isLoadingWithNoValue.value)
    XCTAssertNil(failed.value)
  }

  func test_error() {
    XCTAssertNil(notRequested.error)
    XCTAssertNil(loaded.error)
    XCTAssertNil(isLoadingWithValue.error)
    XCTAssertNil(isLoadingWithNoValue.error)
    XCTAssertNotNil(failed.error)
  }

  func test_map() {
    var value = notRequested
    XCTAssertEqual(
      value.map { $0.prop },
      StringLoadable.notRequested
    )

    value = loaded
    XCTAssertEqual(
      value.map { $0.prop },
      StringLoadable.loaded(model.prop)
    )

    value = isLoadingWithValue
    XCTAssertEqual(
      value.map { $0.prop },
      StringLoadable.isLoading(last: model.prop)
    )

    value = isLoadingWithNoValue
    XCTAssertEqual(
      value.map { $0.prop },
      StringLoadable.isLoading(last: nil)
    )

    value = failed
    XCTAssertEqual(
      value.map { $0.prop },
      StringLoadable.failed(cancelError)
    )
  }

  func test_equals() {
    XCTAssertEqual(notRequested, notRequested)
    XCTAssertEqual(isLoadingWithValue, isLoadingWithValue)
    XCTAssertEqual(isLoadingWithNoValue, isLoadingWithNoValue)
    XCTAssertEqual(loaded, loaded)
    XCTAssertEqual(failed, failed)

    XCTAssertNotEqual(notRequested, isLoadingWithValue)
    XCTAssertNotEqual(notRequested, isLoadingWithNoValue)
    XCTAssertNotEqual(notRequested, loaded)
    XCTAssertNotEqual(notRequested, failed)

    XCTAssertNotEqual(isLoadingWithValue, isLoadingWithNoValue)
    XCTAssertNotEqual(isLoadingWithValue, loaded)
    XCTAssertNotEqual(isLoadingWithValue, failed)

    XCTAssertNotEqual(isLoadingWithNoValue, loaded)
    XCTAssertNotEqual(isLoadingWithNoValue, failed)

    XCTAssertNotEqual(loaded, failed)
  }
}
