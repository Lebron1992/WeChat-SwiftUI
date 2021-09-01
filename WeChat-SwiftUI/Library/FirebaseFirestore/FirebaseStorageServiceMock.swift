import Combine
import Foundation

struct FirebaseStorageServiceMock: FirebaseStorageServiceType {

  let uploadImageResponse: URL?
  let uploadImageError: Error?

  init(
    uploadImageResponse: URL? = nil,
    uploadImageError: Error? = nil
  ) {
    self.uploadImageResponse = uploadImageResponse
    self.uploadImageError = uploadImageError
  }

  func uploadImage(data: Data, format: ImageFormat) -> AnyPublisher<URL, Error> {
    if let error = uploadImageError {
      return .publisher(failure: error)
    }
    return .publisher(output: uploadImageResponse ?? URL(string: "https://example.com/image.png")!)
  }
}
