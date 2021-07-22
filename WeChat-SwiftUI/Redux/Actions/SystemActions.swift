import SwiftUIRedux

enum SystemActions {
  struct SetShowLoading: Action {
    let showLoading: Bool
  }

  struct SetErrorMessage: Action {
    let message: String?
  }
}
