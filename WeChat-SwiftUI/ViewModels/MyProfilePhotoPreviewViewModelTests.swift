import Combine
import XCTest
@testable import WeChat_SwiftUI

final class MyProfilePhotoPreviewViewModelTests: XCTestCase {

  private let viewModel = MyProfilePhotoPreviewViewModel()
  private let testImage = UIImage(color: .white)!

  private var photoUploadStatus = TestObserver<ValueUpdateStatus<URL>, Never>()
  private var photoUploadStatusCancellable: AnyCancellable?

  private var userSelfUpdateStatus = TestObserver<ValueUpdateStatus<User>, Never>()
  private var userSelfUpdateCancellable: AnyCancellable?

  override func setUp() {
    super.setUp()
    photoUploadStatusCancellable = viewModel.$photoUploadStatus
      .sink(
        receiveCompletion: { [weak self] in self?.photoUploadStatus.receiveCompletion($0) },
        receiveValue: { [weak self] in self?.photoUploadStatus.receiveValue($0) }
      )

    userSelfUpdateCancellable = viewModel.$userSelfUpdateStatus
      .sink(
        receiveCompletion: { [weak self] in self?.userSelfUpdateStatus.receiveCompletion($0) },
        receiveValue: { [weak self] in self?.userSelfUpdateStatus.receiveValue($0) }
      )
  }

  override func tearDown() {
    super.tearDown()
    photoUploadStatus.reset()
    photoUploadStatusCancellable?.cancel()

    userSelfUpdateStatus.reset()
    userSelfUpdateCancellable?.cancel()
  }

  func test_uploadPhoto_finished() {
    let url = URL(string: "https://example.com/image.png")!
    let fsService = FirebaseStorageServiceMock(uploadImageResponse: url)

    viewModel.replaceFirebaseStorageService(with: fsService)
    viewModel.uploadPhoto(testImage)

    wait {
      self.photoUploadStatus.assertValues([.idle, .updating, .finished(url)])
    }
  }

  func test_uploadPhoto_failed() {
    let fsService = FirebaseStorageServiceMock(uploadImageError: NSError.unknowError)

    viewModel.replaceFirebaseStorageService(with: fsService)
    viewModel.uploadPhoto(testImage)

    wait {
      self.photoUploadStatus.assertValues([.idle, .updating, .failed(NSError.unknowError)])
    }
  }

  func test_updateUserSelf_finished() {
    let expectation = XCTestExpectation(description: "Wait for response")

    withEnvironment(firestoreService: FirestoreServiceMock()) {
      viewModel.updateUserSelf(.template)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.userSelfUpdateStatus.assertValues([.idle, .updating, .finished(.template)])
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 0.3)
  }

  func test_updateUserSelf_failed() {
    let expectation = XCTestExpectation(description: "Wait for response")
    let service = FirestoreServiceMock(overrideUserError: NSError.unknowError)

    withEnvironment(firestoreService: service) {
      viewModel.updateUserSelf(.template)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.userSelfUpdateStatus.assertValues([.idle, .updating, .failed(NSError.unknowError)])
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 0.3)
  }
}
