import XCTest

extension XCTestCase {
  func wait(interval: TimeInterval = 0.1, completion: @escaping (() -> Void)) {
    let exp = expectation(description: "")
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
      completion()
      exp.fulfill()
    }
    waitForExpectations(timeout: interval + 0.2) // add 0.2 for sure async after called
  }
}
