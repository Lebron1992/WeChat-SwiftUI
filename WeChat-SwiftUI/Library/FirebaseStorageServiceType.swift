import Combine
import Foundation

protocol FirebaseStorageServiceType {
  func uploadImage(data: Data, format: ImageFormat) -> AnyPublisher<URL, Error>
}
