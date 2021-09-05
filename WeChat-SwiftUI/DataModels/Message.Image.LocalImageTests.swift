import XCTest
@testable import WeChat_SwiftUI

final class MessageImageLocalImageTests: XCTestCase {

  func test_progress() {
    var image = Message.Image.LocalImage(uiImage: UIImage(), status: .idle)
    XCTAssertEqual(image.progress, 0)

    image = image.setSatus(.failed(NSError.unknowError))
    XCTAssertEqual(image.progress, 0)

    image = image.setSatus(.uploading(progress: 0.5))
    XCTAssertEqual(image.progress, 0.5)

    image = image.setSatus(.uploaded)
    XCTAssertEqual(image.progress, 1)
  }

  func test_statusEquatable() {
    var s1: Message.Image.LocalImage.Status = .idle
    var s2: Message.Image.LocalImage.Status = .idle
    XCTAssertTrue(s1 == s2)

    s1 = .uploading(progress: 0.5)
    s2 = .uploading(progress: 0.5)
    XCTAssertTrue(s1 == s2)

    s1 = .uploading(progress: 0.6)
    s2 = .uploading(progress: 0.7)
    XCTAssertFalse(s1 == s2)

    s1 = .uploaded
    s2 = .uploaded
    XCTAssertTrue(s1 == s2)

    s1 = .failed(NSError.unknowError)
    s2 = .failed(NSError.unknowError)
    XCTAssertTrue(s1 == s2)

    s1 = .failed(NSError.commonError(description: "hello"))
    s2 = .failed(NSError.commonError(description: "world"))
    XCTAssertFalse(s1 == s2)

    s1 = .uploaded
    s2 = .failed(NSError.unknowError)
    XCTAssertFalse(s1 == s2)
  }
}
