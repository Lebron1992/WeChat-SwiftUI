import Combine
import SwiftUI
import FirebaseAuth

final class OnboardingViewModel: ObservableObject {

  @Published
  var registerStatus: ValueUpdateStatus<AuthDataResult> = .idle
  private var registerCancellable: AnyCancellable?

  @Published
  var signInStatus: ValueUpdateStatus<User> = .idle
  private var signInCancellable: AnyCancellable?

  @Published
  var usernameUpdateStatus: ValueUpdateStatus<User> = .idle
  private var usernameUpdateCancellable: AnyCancellable?

  @Published
  var userSelfUpdateStatus: ValueUpdateStatus<User> = .idle
  private var userSelfUpdateCancellable: AnyCancellable?

  func register(email: String, password: String) {
    registerStatus = .updating
    registerCancellable?.cancel()

    registerCancellable = AppEnvironment.current.authService.register(
      email: email,
      password: password
    )
      .sinkToResultForUI { [weak self] result in
        switch result {
        case .success(let authResult):
          self?.registerStatus = .finished(authResult)
        case let .failure(error):
          self?.registerStatus = .failed(error)
        }
      }
  }

  func signIn(email: String, password: String) {
    signInStatus = .updating
    signInCancellable?.cancel()

    signInCancellable = AppEnvironment.current.authService.signIn(
      email: email,
      password: password
    )
      .sinkToResultForUI { [weak self] result in
        switch result {
        case .success(let firUser):
          self?.signInStatus = .finished(User(firUser: firUser))
        case let .failure(error):
          self?.signInStatus = .failed(error)
        }
      }
  }

  func updateUsername(authResult: AuthDataResult, username: String) {
    usernameUpdateStatus = .updating
    usernameUpdateCancellable?.cancel()

    usernameUpdateCancellable = AppEnvironment.current.authService.updateUsername(
      authResult: authResult,
      username: username
    )
      .sinkToResultForUI { [weak self] result in
        switch result {
        case .success(let firUser):
          self?.usernameUpdateStatus = .finished(User(firUser: firUser))
        case .failure:
          // 改名失败，仍然返回 authResult.user
          self?.usernameUpdateStatus = .finished(User(firUser: authResult.user))
        }
      }
  }

  func updateUserSelf(_ newUser: User) {
    userSelfUpdateStatus = .updating
    userSelfUpdateCancellable?.cancel()

    userSelfUpdateCancellable = AppEnvironment.current.firestoreService
      .overrideUser(newUser)
      .sinkForUI(receiveCompletion: { [weak self] _ in
        // 未考虑错误的情况：因为实际情况中只有把用户保存到数据库中才算注册成功；
        // 这里使用 Firebase 注册，注册成功之后才把用户保存到数据库中，在保存出错的情况下，不方便把已注册的用户删除
        self?.userSelfUpdateStatus = .finished(newUser)
      })
  }
}
