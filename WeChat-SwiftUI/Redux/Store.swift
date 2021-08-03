import SwiftUI
import SwiftUIRedux

let store = Store<AppState>(initialState: AppState(), reducer: appStateReducer)

// MARK: - Global Dispatch
extension View {
  func updateSignedInUser(_ user: User) {
    // token is unnecessary for firestoreService, but we set it to make AppEnvironment works
    let token = "hello-world"
    let tokenEnvelope = AccessTokenEnvelope(accessToken: token, user: user)
    AppEnvironment.login(tokenEnvelope)
    store.dispatch(action: AuthActions.SetSignedInUser(user))
  }

  func setErrorMessage(_ message: String) {
    store.dispatch(action: SystemActions.SetErrorMessage(message: message))
  }
}
