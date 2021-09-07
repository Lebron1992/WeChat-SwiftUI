import Combine
import FirebaseAuth
import FirebaseStorage

struct FirebaseStorageService: FirebaseStorageServiceType {

  private static let storage = Storage.storage(url: "gs://wechat-swiftui.appspot.com")

  func uploadAvatar(data: Data, format: ImageFormat) -> AnyPublisher<URL, Error> {
    uploadImageData(
      data,
      toPath: ["images", "avatars", "\(generateUUID()).\(format.fileExtension)"].joined(separator: "/"),
      in: format
    )
  }

  func uploadImageData(
    _ data: Data,
    for message: Message,
    in format: ImageFormat,
    progress: @escaping ((Double) -> Void)
  ) -> AnyPublisher<URL, Error> {

    uploadImageData(
      data,
      toPath: ["messages", message.id, "images", "\(generateUUID()).\(format.fileExtension)"].joined(separator: "/"),
      in: format,
      progress: progress
    )
  }
}

// MARK: - Helper Methods
private extension FirebaseStorageService {
  func uploadImageData(
    _ data: Data,
    toPath path: String,
    in format: ImageFormat,
    progress: ((Double) -> Void)? = nil
  ) -> AnyPublisher<URL, Error> {

    Future { promise in
      let imageRef = Self.storage.reference().child(path)
      let metadata = StorageMetadata()
      metadata.contentType = format.contentType

      let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in

        guard metadata != nil else {
          if let err = error {
            promise(.failure(err))
          } else {
            promise(.failure(NSError.unknowError))
          }
          return
        }

        imageRef.downloadURL { url, error in
          if let url = url {
            promise(.success(url))
          } else if let err = error {
            promise(.failure(err))
          } else {
            promise(.failure(NSError.unknowError))
          }
        }
      }

      uploadTask.observe(.progress) { snapshot in
        if let p = snapshot.progress {
          let percentage = Double(p.completedUnitCount) / Double(p.totalUnitCount)
          progress?(percentage)
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
