import Combine
import Foundation

protocol FirebaseStorageServiceType {
  func uploadAvatar(data: Data, format: ImageFormat) -> AnyPublisher<URL, Error>

  func uploadImageData(
    _ data: Data,
    for message: Message,
    in format: ImageFormat,
    progress: @escaping ((Double) -> Void)
  ) -> AnyPublisher<URL, Error>
}
