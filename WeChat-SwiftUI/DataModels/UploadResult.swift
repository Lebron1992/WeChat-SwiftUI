import Foundation
import LBJPublishers

struct UploadResult: Equatable {
  let progress: Double
  let url: URL?
}

extension UploadResult {
  static let uploading: UploadResult = .init(progress: 0.5, url: nil)
  static let imageFinished: UploadResult = .init(progress: 1, url: URL(string: "https://example.com/image.png"))
}

extension LoadResult where R == URL {
  func toUploadResult() -> UploadResult {
    .init(progress: progress, url: result)
  }
}
