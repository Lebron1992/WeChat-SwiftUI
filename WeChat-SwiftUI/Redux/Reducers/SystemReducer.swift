import SwiftUIRedux

func systemStateReducer(state: SystemState, action: Action) -> SystemState {
  var newState = state
  switch action {
  case let action as SystemActions.SetErrorMessage:
    newState.errorMessage = action.message
  default:
    break
  }
  return newState
}
