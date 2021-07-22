import SwiftUIRedux

enum AuthActions {
  struct SetSignedInUser: Action {
    let user: User?
  }
}
