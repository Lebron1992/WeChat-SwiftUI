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
    let fsService = FirebaseStorageServiceMock(uploadAvatarResponse: url)

    viewModel.replaceFirebaseStorageService(with: fsService)
    viewModel.uploadPhoto(testImage)

    wait {
      self.photoUploadStatus.assertValues([.idle, .updating, .finished(url)])
    }
  }

  func test_uploadPhoto_failed() {
    let fsService = FirebaseStorageServiceMock(uploadAvatarError: NSError.unknowError)

    viewModel.replaceFirebaseStorageService(with: fsService)
    viewModel.uploadPhoto(testImage)

    wait {
      self.photoUploadStatus.assertValues([.idle, .updating, .failed(NSError.unknowError.toEnvelope())])
    }
  }

  func test_updateUserSelf_finished() async {
    let expectation = XCTestExpectation(description: "Wait for response")

    await withEnvironment(firestoreService: FirestoreServiceMock()) {
      await viewModel.updateUserSelf(.template1)
      self.userSelfUpdateStatus.assertValues([.idle, .updating, .finished(.template1)])
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.3)
  }

  func test_updateUserSelf_failed() async {
    let expectation = XCTestExpectation(description: "Wait for response")
    let service = FirestoreServiceMock(overrideUserError: NSError.unknowError)

    await withEnvironment(firestoreService: service) {
      await viewModel.updateUserSelf(.template1)
      self.userSelfUpdateStatus.assertValues([.idle, .updating, .failed(NSError.unknowError)])
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.3)
  }
}
