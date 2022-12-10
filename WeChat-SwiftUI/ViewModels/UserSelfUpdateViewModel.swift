import Combine
import SwiftUI

class UserSelfUpdateViewModel: ObservableObject {

  @Published @MainActor
  private(set) var userSelfUpdateStatus: ValueUpdateStatus<User> = .idle
  private var updateTask: Task<Void, Never>?

  func updateUserSelf(_ newUser: User) async {
    await MainActor.run { userSelfUpdateStatus = .updating }
    updateTask = Task {
      do {
        try await AppEnvironment.current.firestoreService.overrideUser(newUser)
        if !Task.isCancelled {
          await MainActor.run { userSelfUpdateStatus = .finished(newUser) }
        }
      } catch {
        await MainActor.run { userSelfUpdateStatus = .failed(error) }
      }
    }
    await updateTask?.value
  }

  func cancelUpdateUserSelf() async {
    updateTask?.cancel()
    await MainActor.run { userSelfUpdateStatus = .idle }
  }
}
