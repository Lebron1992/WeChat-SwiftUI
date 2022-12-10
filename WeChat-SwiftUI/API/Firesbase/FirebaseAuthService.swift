import Combine
import FirebaseAuth

struct FirebaseAuthService: FirebaseAuthServiceType {

  func register(email: String, password: String) async throws -> AuthDataResult {
    try await withCheckedThrowingContinuation({ continuation in
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else if let result = result {
          continuation.resume(returning: result)
        } else {
          continuation.resume(throwing: NSError.unknowError)
        }
      }
    })
  }

  func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
    try await withCheckedThrowingContinuation({ continuation in
      Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else if let result = result {
          continuation.resume(returning: result.user)
        } else {
          continuation.resume(throwing: NSError.unknowError)
        }
      }
    })
  }

  func updateUsername(authResult: AuthDataResult, username: String) async throws -> FirebaseAuth.User {
      try await withCheckedThrowingContinuation({ continuation in
      let request = authResult.user.createProfileChangeRequest()
      request.displayName = username
      request.commitChanges { error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: authResult.user)
        }
      }
    })
  }
}
