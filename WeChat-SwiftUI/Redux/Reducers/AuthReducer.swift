import Foundation
import SwiftUIRedux

func authStateReducer(state: AuthState, action: Action) -> AuthState {
  var newState = state
  switch action {
  case let action as AuthActions.SetSignedInUser:
    newState.signedInUser = action.user
  default:
    break
  }
  return newState
}
