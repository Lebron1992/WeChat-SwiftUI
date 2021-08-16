import Combine
import XCTest

struct TestObserver<Value, Error: Swift.Error> {

  private(set) var values: [Value] = []

  mutating func receiveCompletion(_ completion: Subscribers.Completion<Error>) {

  }

  mutating func receiveValue(_ value: Value) {
    values.append(value)
  }

  var lastValue: Value? {
    values.last
  }

  mutating func reset() {
    values = []
  }
}

extension TestObserver where Value: Equatable {
  func assertValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(1, values.count, "A single item should have been emitted.", file: file, line: line)
    XCTAssertEqual(value, self.lastValue, message ?? "A single value of \(value) should have been emitted",
                   file: file, line: line)
  }

  func assertValues(
    _ values: [Value],
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(values, self.values, message, file: file, line: line)
  }
}
