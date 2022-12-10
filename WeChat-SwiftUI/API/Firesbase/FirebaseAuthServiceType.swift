import Combine
import FirebaseAuth

protocol FirebaseAuthServiceType {
  func register(email: String, password: String) async throws -> AuthDataResult
  func signIn(email: String, password: String) async throws -> FirebaseAuth.User
  func updateUsername(authResult: AuthDataResult, username: String) async throws -> FirebaseAuth.User
}
