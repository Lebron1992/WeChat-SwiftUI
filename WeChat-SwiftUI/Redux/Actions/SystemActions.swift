import SwiftUIRedux

enum SystemActions {
  struct SetErrorMessage: Action, Equatable {
    let message: String?
  }
}
