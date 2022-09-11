import Combine
import ComposableArchitecture

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

  func uploadAvatar(data: Data, format: ImageFormat) -> Effect<URL, ErrorEnvelope> {
    if let error = uploadAvatarError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: uploadAvatarResponse ?? URL(string: "https://example.com/image.png")!)
  }

  func uploadImageData(
    _ data: Data,
    for message: Message,
    in format: ImageFormat,
    progress: @escaping ((Double) -> Void)
  ) -> Effect<URL, ErrorEnvelope> {
    // TODO: 支持进度
    if let error = uploadMessageImageError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: uploadMessageImageResponse ?? URL(string: "https://example.com/image.png")!)
  }
}
