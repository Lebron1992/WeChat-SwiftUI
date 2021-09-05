import UIKit

extension Message.Image {
  struct LocalImage {
    let uiImage: UIImage
    let status: Status
  }
}

extension Message.Image.LocalImage {
  var progress: Float {
    switch status {
    case .idle, .failed:
      return 0
    case .uploading(let progress):
      return progress
    case .uploaded:
      return 1
    }
  }
}

extension Message.Image.LocalImage: Equatable { }

extension Message.Image.LocalImage {
  enum Status {
    case idle
    case uploading(progress: Float)
    case uploaded
    case failed(Error)
  }
}

extension Message.Image.LocalImage.Status: Equatable {
  static func == (lhs: Message.Image.LocalImage.Status, rhs: Message.Image.LocalImage.Status) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.uploading(let lp), .uploading(let rp)):
      return lp == rp
    case (.uploaded, .uploaded):
      return true
    case (.failed(let le), .failed(let re)):
      return le.localizedDescription == re.localizedDescription
    default:
      return false
    }
  }
}

#if DEBUG
extension Message.Image.LocalImage {
  static let testUIImage1 = UIImage(named: "IMG_0004")!
  static let testUIImage2 = UIImage(named: "IMG_0001")!
}
#endif
