import Combine
import FirebaseAuth

/// 返回值无法初始化，无法进行 Mock
struct FirebaseAuthServiceMock: FirebaseAuthServiceType {
  func register(email: String, password: String) async throws -> AuthDataResult {
    // AuthDataResult 无法手动初始化
    throw NSError.unknowError
  }

  func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
    // FirebaseAuth.User 无法手动初始化
    throw NSError.unknowError
  }

  func updateUsername(authResult: AuthDataResult, username: String) async throws -> FirebaseAuth.User {
    // FirebaseAuth.User 无法手动初始化
    throw NSError.unknowError
  }
}
