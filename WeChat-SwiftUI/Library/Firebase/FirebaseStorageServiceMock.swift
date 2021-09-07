import Combine
import Foundation

struct FirebaseStorageServiceMock: FirebaseStorageServiceType {

  let uploadAvatarResponse: URL?
  let uploadAvatarError: Error?

  let uploadMessageImageProgress: Float?
  let uploadMessageImageResponse: URL?
  let uploadMessageImageError: Error?

  init(
    uploadAvatarResponse: URL? = nil,
    uploadAvatarError: Error? = nil,
    uploadMessageImageProgress: Float? = nil,
    uploadMessageImageResponse: URL? = nil,
    uploadMessageImageError: Error? = nil
  ) {
    self.uploadAvatarResponse = uploadAvatarResponse
    self.uploadAvatarError = uploadAvatarError

    self.uploadMessageImageProgress = uploadMessageImageProgress
    self.uploadMessageImageResponse = uploadMessageImageResponse
    self.uploadMessageImageError = uploadMessageImageError
  }

  func uploadAvatar(data: Data, format: ImageFormat) -> AnyPublisher<URL, Error> {
    if let error = uploadAvatarError {
      return .publisher(failure: error)
    }
    return .publisher(output: uploadAvatarResponse ?? URL(string: "https://example.com/image.png")!)
  }

  func uploadImageData(
    _ data: Data,
    for message: Message,
    in format: ImageFormat,
    progress: @escaping ((Double) -> Void)
  ) -> AnyPublisher<URL, Error> {
    Future { promise in
      if let pgs = uploadMessageImageProgress {
        wait(interval: 0.5) {
          progress(Double(pgs))
        }
      }
      wait(interval: 1) {
        if let error = uploadMessageImageError {
          promise(.failure(error))
        }
        promise(.success(uploadMessageImageResponse ?? URL(string: "https://example.com/image.png")!))
      }
    }
    .eraseToAnyPublisher()
  }
}
