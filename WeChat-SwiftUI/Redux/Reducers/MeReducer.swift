import SwiftUIRedux

func meStateReducer(state: MeState, action: Action) -> MeState {
  var newState = state
  switch action {
  case let action as MeActions.SetUserSelf:
    newState.userSelf = action.userSelf
  default:
    break
  }
  return newState
}
