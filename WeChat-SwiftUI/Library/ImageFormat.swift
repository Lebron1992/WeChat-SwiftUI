import Foundation

enum ImageFormat {
  case png
  case jpg

  var fileExtension: String {
    switch self {
    case .png: return "png"
    case .jpg: return "jpg"
    }
  }

  var contentType: String {
    switch self {
    case .png: return "image/png"
    case .jpg: return "image/jpeg"
    }
  }
}
