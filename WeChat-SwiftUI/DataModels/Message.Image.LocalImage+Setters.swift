import Foundation

extension Message.Image.LocalImage {
  func setSatus(_ status: Status) -> Message.Image.LocalImage {
    .init(uiImage: uiImage, status: status)
  }
}
