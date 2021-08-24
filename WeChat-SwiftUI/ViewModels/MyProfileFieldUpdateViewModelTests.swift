import Combine
import XCTest
@testable import WeChat_SwiftUI

final class MyProfileFieldUpdateViewModelTests: XCTestCase {

  private let viewModel = MyProfileFieldUpdateViewModel()

  private var userSelfUpdateStatus = TestObserver<ValueUpdateStatus<User>, Never>()
  private var userSelfUpdateCancellable: AnyCancellable?

  override func setUp() {
    super.setUp()
    userSelfUpdateCancellable = viewModel.$userSelfUpdateStatus
      .sink(
        receiveCompletion: { [weak self] in self?.userSelfUpdateStatus.receiveCompletion($0) },
        receiveValue: { [weak self] in self?.userSelfUpdateStatus.receiveValue($0) }
      )
  }

  override func tearDown() {
    super.tearDown()

    userSelfUpdateStatus.reset()
    userSelfUpdateCancellable?.cancel()
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
