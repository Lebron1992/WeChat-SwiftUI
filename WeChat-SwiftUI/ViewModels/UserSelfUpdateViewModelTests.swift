import Combine
import XCTest
@testable import WeChat_SwiftUI

final class UserSelfUpdateViewModelTests: XCTestCase {

  private let viewModel = UserSelfUpdateViewModel()

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
