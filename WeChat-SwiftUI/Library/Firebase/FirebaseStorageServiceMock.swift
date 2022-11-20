import Combine
import Foundation
import ComposableArchitecture

struct FirebaseStorageServiceMock: FirebaseStorageServiceType {

  let uploadAvatarResponse: URL?
  let uploadAvatarError: Error?

  let uploadMessageImageResponse: UploadResult?
  let uploadMessageImageError: Error?

  init(
    uploadAvatarResponse: URL? = nil,
    uploadAvatarError: Error? = nil,
    uploadMessageImageResponse: UploadResult? = nil,
    uploadMessageImageError: Error? = nil
  ) {
    self.uploadAvatarResponse = uploadAvatarResponse
    self.uploadAvatarError = uploadAvatarError

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
    in format: ImageFormat
  ) -> Effect<UploadResult, ErrorEnvelope> {
    if let error = uploadMessageImageError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: uploadMessageImageResponse ?? .imageFinished)
  }
}
