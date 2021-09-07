import XCTest
@testable import WeChat_SwiftUI

final class MessageImageTests: XCTestCase {

  func test_url() {
    XCTAssertEqual(
      Message.Image.urlTemplate.url, "https://example.com/test.png")
    XCTAssertNil(Message.Image.uiImageTemplateIdle.url)
  }

  func teset_uiImage() {
    XCTAssertNil(Message.Image.urlTemplate.uiImage)
    XCTAssertEqual(
      Message.Image.uiImageTemplateIdle.uiImage, Message.Image.LocalImage.testUIImage1)
  }

  func test_isUploadFailed() {
    var image = Message.Image()
    XCTAssertFalse(image.isUploadFailed)

    image = .urlTemplate
    XCTAssertFalse(image.isUploadFailed)

    image = .uiImageTemplateIdle
    XCTAssertFalse(image.isUploadFailed)

    image = .uiImageTemplateUploaded
    XCTAssertFalse(image.isUploadFailed)

    image = .uiImageTemplateError
    XCTAssertTrue(image.isUploadFailed)
  }

  func test_size() {
    var image = Message.Image(
      urlImage: .init(url: "", width: 300, height: 200),
      localImage: nil
    )
    XCTAssertEqual(image.size, .init(width: 300, height: 200))

    let uiImage = UIImage()
    image = Message.Image(
      urlImage: nil,
      localImage: .init(uiImage: uiImage, status: .idle)
    )
    XCTAssertEqual(image.size, uiImage.size)
  }

  func test_progress() {
    XCTAssertEqual(Message.Image.urlTemplate.progress, 1)

    let localImage = Message.Image.LocalImage(uiImage: UIImage(), status: .idle)
    let image = Message.Image(
      urlImage: nil,
      localImage: localImage
    )
    XCTAssertEqual(image.progress, localImage.progress)
  }

  func test_equatable() {
    XCTAssertEqual(Message.Image.urlTemplate, Message.Image.urlTemplate)
    XCTAssertNotEqual(Message.Image.urlTemplate, Message.Image.uiImageTemplateIdle)
  }

  func test_description() {
    XCTAssertNotEqual("", Message.Image.urlTemplate.debugDescription)
    XCTAssertNotEqual("", Message.Image.uiImageTemplateIdle.debugDescription)
  }

  func test_jsonParsing() {
    let json = """
      {
        "urlImage": {
          "url": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
          "width": 260,
          "height": 190
        }
      }
      """

    let image: Message.Image? = tryDecode(json)

    XCTAssertNotNil(image?.urlImage)
    XCTAssertNil(image?.uiImage)
    XCTAssertEqual(image?.urlImage?.url, "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png")
    XCTAssertEqual(image?.urlImage?.width, 260)
    XCTAssertEqual(image?.urlImage?.height, 190)
  }
}
