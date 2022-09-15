import Combine
import ComposableArchitecture
import FirebaseAuth
import FirebaseStorage
import LBJPublishers

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
    in format: ImageFormat
  ) -> Effect<UploadResult, ErrorEnvelope> {

    uploadImageData(
      data,
      toPath: ["messages", message.id, "images", "\(generateUUID()).\(format.fileExtension)"].joined(separator: "/"),
      in: format
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

  func uploadImageData(
    _ data: Data,
    toPath path: String,
    in format: ImageFormat
  ) -> Effect<UploadResult, ErrorEnvelope> {

    let imageRef = Self.storage.reference().child(path)
    let metadata = StorageMetadata()
    metadata.contentType = format.contentType

    let uploader = FirebaseStorageImageUploader(ref: imageRef, data: data, metadata: metadata)

    return Publishers.ProgressResult(loader: uploader)
      .map { $0.toUploadResult() }
      .mapError { $0.toEnvelope() }
      .eraseToEffect()
  }
}

private class FirebaseStorageImageUploader: ProgressResultLoader {

  let ref: StorageReference
  let data: Data
  let metadata: StorageMetadata

  var uploadTask: StorageUploadTask?

  init(ref: StorageReference, data: Data, metadata: StorageMetadata) {
    self.ref = ref
    self.data = data
    self.metadata = metadata
  }

  func startLoading(progress: @escaping (Double) -> Void, completion: @escaping (URL?, Error?) -> Void) {
    let uploadTask = ref.putData(data, metadata: metadata) { [weak self] (metadata, error) in

      guard metadata != nil else {
        completion(nil, error)
        return
      }

      self?.ref.downloadURL { url, error in
        if let url = url {
          completion(url, nil)
        } else {
          completion(nil, error)
        }
      }
    }

    uploadTask.observe(.progress) { snapshot in
      if let p = snapshot.progress {
        let percentage = Double(p.completedUnitCount) / Double(p.totalUnitCount)
        progress(percentage)
      }
    }

    self.uploadTask = uploadTask
  }

  func cancelLoading() {
    uploadTask?.cancel()
  }
}
