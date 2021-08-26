import SwiftUI
import SwiftUIRedux

let store = Store<AppState>(initialState: AppState(), reducer: appStateReducer)

// MARK: - Global Dispatch
extension View {
  func updateSignedInUser(_ user: User?) {
    store.dispatch(action: AuthActions.SetSignedInUser(user: user))
  }

  func setErrorMessage(_ message: String) {
    store.dispatch(action: SystemActions.SetErrorMessage(message: message))
  }
}
