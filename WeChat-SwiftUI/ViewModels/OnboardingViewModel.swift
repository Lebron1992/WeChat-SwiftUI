import Combine
import SwiftUI
import FirebaseAuth

final class OnboardingViewModel: ObservableObject {

  @Published @MainActor
  private(set) var registerStatus: ValueUpdateStatus<AuthDataResult> = .idle

  @Published @MainActor
  private(set) var signInStatus: ValueUpdateStatus<User> = .idle

  @Published @MainActor
  private(set) var usernameUpdateStatus: ValueUpdateStatus<User> = .idle

  @Published @MainActor
  private(set) var userSelfUpdateStatus: ValueUpdateStatus<User> = .idle

  func register(email: String, password: String) async {
    await MainActor.run { registerStatus = .updating }
    await Task {
      do {
        let result = try await AppEnvironment.current.authService
          .register(email: email, password: password)
        if !Task.isCancelled {
          await MainActor.run { registerStatus = .finished(result) }
        }
      } catch {
        await MainActor.run { registerStatus = .failed(error) }
      }
    }.value
  }

  func signIn(email: String, password: String) async {
    await MainActor.run { signInStatus = .updating }
    await Task {
      do {
        let firUser = try await AppEnvironment.current.authService
          .signIn(email: email, password: password)
        if !Task.isCancelled {
          await MainActor.run { signInStatus = .finished(User(firUser: firUser)) }
        }
      } catch {
        await MainActor.run { signInStatus = .failed(error) }
      }
    }.value
  }

  func updateUsername(authResult: AuthDataResult, username: String) async {
    await MainActor.run { usernameUpdateStatus = .updating }
    await Task {
      do {
        let firUser = try await AppEnvironment.current.authService
          .updateUsername(authResult: authResult, username: username)
        if !Task.isCancelled {
          await MainActor.run { usernameUpdateStatus = .finished(User(firUser: firUser)) }
        }
      } catch {
        // 改名失败，仍然返回 authResult.user
        await MainActor.run { usernameUpdateStatus = .finished(User(firUser: authResult.user)) }
      }
    }.value
  }

  func updateUserSelf(_ newUser: User) async {
    await MainActor.run { userSelfUpdateStatus = .updating }
    await Task {
      do {
        try await AppEnvironment.current.firestoreService.overrideUser(newUser)
        await MainActor.run { userSelfUpdateStatus = .finished(newUser) }
      } catch {
        // 未考虑错误的情况：因为实际情况中只有把用户保存到数据库中才算注册成功；
        // 这里使用 Firebase 注册，注册成功之后才把用户保存到数据库中，在保存出错的情况下，不方便把已注册的用户删除
        await MainActor.run { userSelfUpdateStatus = .finished(newUser) }
      }
    }.value
  }
}
