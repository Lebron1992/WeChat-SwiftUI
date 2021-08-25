import Combine
import FirebaseAuth

protocol FirebaseAuthServiceType {

  func register(email: String, password: String) -> AnyPublisher<AuthDataResult, Error>

  func signIn(email: String, password: String) -> AnyPublisher<FirebaseAuth.User, Error>

  func updateUsername(authResult: AuthDataResult, username: String) -> AnyPublisher<FirebaseAuth.User, Error>
}
