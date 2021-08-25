import Combine
import FirebaseAuth

struct FirebaseAuthService: FirebaseAuthServiceType {

  func register(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
    Future { promise in
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          promise(.failure(error))
        } else if let result = result {
          promise(.success(result))
        } else {
          promise(.failure(NSError.unknowError))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func signIn(email: String, password: String) -> AnyPublisher<FirebaseAuth.User, Error> {
    Future { promise in
      Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if let error = error {
          promise(.failure(error))
        } else if let result = result {
          promise(.success(result.user))
        } else {
          promise(.failure(NSError.unknowError))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func updateUsername(authResult: AuthDataResult, username: String) -> AnyPublisher<FirebaseAuth.User, Error> {
    Future { promise in
      let request = authResult.user.createProfileChangeRequest()
      request.displayName = username
      request.commitChanges { error in
        if let error = error {
          promise(.failure(error))
        } else {
          promise(.success(authResult.user))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
