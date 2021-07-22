import Foundation

struct AuthState {
  var signedInUser: User?
}

extension AuthState: Equatable {
  static func == (lhs: AuthState, rhs: AuthState) -> Bool {
    lhs.signedInUser == lhs.signedInUser
  }
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
