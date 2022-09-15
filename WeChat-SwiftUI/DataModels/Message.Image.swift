import UIKit

extension Message {
  struct Image {
    let urlImage: URLImage?
    let localImage: LocalImage?

    init(uiImage: UIImage, status: LocalImage.Status = .idle) {
      urlImage = nil
      localImage = .init(uiImage: uiImage, status: status)
    }

    init(urlImage: URLImage? = nil, localImage: LocalImage? = nil) {
      self.urlImage = urlImage
      self.localImage = localImage
    }
  }
}

extension Message.Image {
  var url: String? {
    urlImage?.url
  }

  var uiImage: UIImage? {
    localImage?.uiImage
  }

  var isUploadFailed: Bool {
    guard let localImage = localImage else {
      return false
    }
    switch localImage.status {
    case .failed:
      return true
    default:
      return false
    }
  }

  var size: CGSize {
    if let urlImage = urlImage {
      return .init(width: urlImage.width, height: urlImage.height)
    }
    return localImage?.uiImage.size ?? .zero
  }

  var progress: Float {
    if urlImage.isSome {
      return 1
    }
    return localImage?.progress ?? 1
  }
}

extension Message.Image: Codable {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    urlImage = try values.decodeIfPresent(URLImage.self, forKey: .urlImage)
    localImage = nil
  }

  enum CodingKeys: String, CodingKey {
    case urlImage
  }
}

extension Message.Image: Equatable { }

extension Message.Image: CustomDebugStringConvertible {
  var debugDescription: String {
    switch (urlImage?.url, uiImage) {
    case let (.some(url), .some):
      return "URLImage: \(url); UIImage"
    case let (.some(url), .none):
      return "URLImage: \(url)"
    case (.none, .some):
      return "UIImage"
    default:
      return "No image"
    }
  }
}
