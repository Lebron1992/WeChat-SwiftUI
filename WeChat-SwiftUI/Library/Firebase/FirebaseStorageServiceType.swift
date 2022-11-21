import Combine
import Foundation
import ComposableArchitecture

protocol FirebaseStorageServiceType {
  func uploadAvatar(data: Data, format: ImageFormat) -> Effect<URL, ErrorEnvelope>
  func uploadImageData(
    _ data: Data,
    for message: Message,
    in format: ImageFormat
  ) -> Effect<UploadResult, ErrorEnvelope>
}
