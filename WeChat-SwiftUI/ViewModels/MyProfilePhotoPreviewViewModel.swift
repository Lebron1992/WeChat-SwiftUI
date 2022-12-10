import Combine
import SwiftUI

final class MyProfilePhotoPreviewViewModel: UserSelfUpdateViewModel {

  private var fsService: FirebaseStorageServiceType

  init(fsService: FirebaseStorageServiceType = FirebaseStorageService()) {
    self.fsService = fsService
  }

  @Published
  private(set) var photoUploadStatus: ValueUpdateStatus<URL> = .idle
  private var photoUploadCancellable: AnyCancellable?

  func uploadPhoto(_ image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 0.5) else {
      return
    }

    photoUploadStatus = .updating
    photoUploadCancellable?.cancel()

    photoUploadCancellable = fsService.uploadAvatar(data: data, format: .png)
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
}

// MARK: - Getters
extension MyProfilePhotoPreviewViewModel {
  @MainActor
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
