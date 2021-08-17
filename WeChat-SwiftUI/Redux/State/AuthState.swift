import Foundation

struct AuthState: Codable, Equatable {
  var signedInUser: User?
}

#if DEBUG
extension AuthState {
  static var preview: AuthState {
    AuthState(
      signedInUser: nil
    )
  }
}
#endif
