import Combine
import ComposableArchitecture

protocol FirebaseStorageServiceType {
  func uploadAvatar(data: Data, format: ImageFormat) -> Effect<URL, ErrorEnvelope>

  func uploadImageData(
    _ data: Data,
    for message: Message,
    in format: ImageFormat,
    progress: @escaping ((Double) -> Void)
  ) -> Effect<URL, ErrorEnvelope>
}
