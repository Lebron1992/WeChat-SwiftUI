import Foundation

extension Message.Image {
  func setStatus(_ status: Message.Image.LocalImage.Status) -> Message.Image {
    .init(localImage: localImage?.setSatus(status))
  }
}
