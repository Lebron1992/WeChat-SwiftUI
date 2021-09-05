import XCTest
import SwiftUI
@testable import WeChat_SwiftUI

final class CGSize_AspectSizeTests: XCTestCase {
  func test_aspectSizeFitsSize() {
    let containerSize = CGSize(width: 10, height: 20)

    var originalSize = CGSize(width: 20, height: 30)
    var expectedSize = CGSize(width: 10, height: 15)
    XCTAssertEqual(originalSize.aspectSize(fitsSize: containerSize), expectedSize)

    originalSize = CGSize(width: 20, height: 50)
    expectedSize = CGSize(width: 8, height: 20)
    XCTAssertEqual(originalSize.aspectSize(fitsSize: containerSize), expectedSize)
  }
}
