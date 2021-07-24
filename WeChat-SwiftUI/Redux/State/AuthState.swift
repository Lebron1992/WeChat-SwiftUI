import Foundation

struct AuthState: Codable {
  var signedInUser: User?
}

extension AuthState: Equatable {
  static func == (lhs: AuthState, rhs: AuthState) -> Bool {
    lhs.signedInUser == rhs.signedInUser
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
