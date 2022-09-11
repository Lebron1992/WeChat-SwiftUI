import Combine
import ComposableArchitecture
import FirebaseAuth
import FirebaseStorage

struct FirebaseStorageService: FirebaseStorageServiceType {

  private static let storage = Storage.storage(url: "gs://wechat-swiftui.appspot.com")

  func uploadAvatar(data: Data, format: ImageFormat) -> Effect<URL, ErrorEnvelope> {
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
  ) -> Effect<URL, ErrorEnvelope> {

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
  ) -> Effect<URL, ErrorEnvelope> {

    Effect.future { promise in
      let imageRef = Self.storage.reference().child(path)
      let metadata = StorageMetadata()
      metadata.contentType = format.contentType

      let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in

        guard metadata != nil else {
          if let err = error {
            promise(.failure(err.toEnvelope()))
          } else {
            promise(.failure(NSError.unknowError.toEnvelope()))
          }
          return
        }

        imageRef.downloadURL { url, error in
          if let url = url {
            promise(.success(url))
          } else if let err = error {
            promise(.failure(err.toEnvelope()))
          } else {
            promise(.failure(NSError.unknowError.toEnvelope()))
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
  }
}
