import UIKit

extension Message.Image {
  static let urlTemplate = Message.Image(
    urlImage: .init(
      url: "https://example.com/test.png",
      width: 300,
      height: 200
    )
  )

  static let uiImageTemplateIdle = Message.Image(
    uiImage: Message.Image.LocalImage.testUIImage1,
    status: .idle
  )

  static let uiImageTemplateUploaded = Message.Image(
    uiImage: Message.Image.LocalImage.testUIImage2,
    status: .uploaded
  )

  static let uiImageTemplateError = Message.Image(
    uiImage: Message.Image.LocalImage.testUIImage2,
    status: .failed(NSError.unknowError)
  )
}
