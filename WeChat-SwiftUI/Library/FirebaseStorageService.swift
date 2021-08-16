import Combine
import FirebaseAuth
import FirebaseStorage

struct FirebaseStorageService: FirebaseStorageServiceType {

  private static let storage = Storage.storage(url: "gs://wechat-swiftui.appspot.com")

  func uploadImage(data: Data, format: ImageFormat) -> AnyPublisher<URL, Error> {
    Future { promise in

      let id = UUID().uuidString.lowercased()
      let imageRef = Self.storage.reference().child("images/avatars/\(id).\(format.fileExtension)")

      let metadata = StorageMetadata()
      metadata.contentType = format.contentType

      imageRef.putData(data, metadata: metadata) { (metadata, error) in

        guard metadata != nil else {
          if let err = error {
            promise(Result.failure(err))
          } else {
            promise(Result.failure(NSError.unknowError))
          }
          return
        }

        imageRef.downloadURL { url, error in
          if let url = url {
            promise(Result.success(url))
          } else if let err = error {
            promise(Result.failure(err))
          } else {
            promise(Result.failure(NSError.unknowError))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
