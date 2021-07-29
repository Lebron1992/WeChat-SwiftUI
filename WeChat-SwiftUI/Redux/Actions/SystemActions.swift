import SwiftUIRedux

enum SystemActions {
  struct SetErrorMessage: Action {
    let message: String?
  }
}
