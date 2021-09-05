import Foundation

extension Message.Image {
  func setStatus(_ status: Message.Image.LocalImage.Status) -> Message.Image {
    Message.Image(
      urlImage: urlImage,
      localImage: localImage?.setSatus(status)
    )
  }
}
