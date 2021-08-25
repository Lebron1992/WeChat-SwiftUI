import Combine
import SwiftUI

final class MyProfilePhotoPreviewViewModel: ObservableObject {

  private var fsService: FirebaseStorageServiceType

  init(fsService: FirebaseStorageServiceType = FirebaseStorageService()) {
    self.fsService = fsService
  }

  @Published
  var photoUploadStatus: ValueUpdateStatus<URL> = .idle
  private var photoUploadCancellable: AnyCancellable?

  @Published
  var userSelfUpdateStatus: ValueUpdateStatus<User> = .idle
  private var userSelfUpdateCancellable: AnyCancellable?

  func uploadPhoto(_ image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 0.5) else {
      return
    }

    photoUploadStatus = .updating
    photoUploadCancellable?.cancel()

    photoUploadCancellable = fsService.uploadImage(data: data, format: .png)
      .sinkForUI(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .failure(let error):
            self?.photoUploadStatus = .failed(error)
          default:
            break
          }
        },
        receiveValue: { [weak self] url in
          self?.photoUploadStatus = .finished(url)
        }
      )
  }

  func updateUserSelf(_ newUser: User) {
    userSelfUpdateStatus = .updating
    userSelfUpdateCancellable?.cancel()

    userSelfUpdateCancellable = AppEnvironment.current.firestoreService
      .overrideUser(newUser)
      .sinkForUI(receiveCompletion: { [weak self] completion in

        switch completion {
        case .finished:
          self?.userSelfUpdateStatus = .finished(newUser)
        case let .failure(error):
          self?.userSelfUpdateStatus = .failed(error)
        }
      })
  }
}

// MARK: - Getters
extension MyProfilePhotoPreviewViewModel {
  var isUserSelfUpdated: Bool {
    userSelfUpdateStatus.value != nil
  }
}

// MARK: - Test Helpers
extension MyProfilePhotoPreviewViewModel {
  func replaceFirebaseStorageService(with service: FirebaseStorageServiceType) {
    fsService = service
  }
}
