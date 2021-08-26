import Foundation
import SwiftUIRedux

func authStateReducer(state: AuthState, action: Action) -> AuthState {
  var newState = state
  switch action {
  case let action as AuthActions.SetSignedInUser:
    newState.signedInUser = action.user

    if let user = action.user {
      // token is unnecessary for firestoreService, but we set it to make AppEnvironment works
      let tokenEnvelope = AccessTokenEnvelope(accessToken: "deadbeef", user: user)
      AppEnvironment.login(tokenEnvelope)
    } else {
      AppEnvironment.logout()
    }

  default:
    break
  }
  return newState
}
