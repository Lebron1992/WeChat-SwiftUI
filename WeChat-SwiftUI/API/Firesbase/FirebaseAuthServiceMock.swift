import Combine
import FirebaseAuth

/// 返回值无法初始化，无法进行 Mock
struct FirebaseAuthServiceMock: FirebaseAuthServiceType {

  func register(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
    // AuthDataResult 无法手动初始化
    .publisher(failure: NSError.unknowError)
  }

  func signIn(email: String, password: String) -> AnyPublisher<FirebaseAuth.User, Error> {
    // FirebaseAuth.User 无法手动初始化
    .publisher(failure: NSError.unknowError)
  }

  func updateUsername(authResult: AuthDataResult, username: String) -> AnyPublisher<FirebaseAuth.User, Error> {
    // FirebaseAuth.User 无法手动初始化
    .publisher(failure: NSError.unknowError)
  }
}
