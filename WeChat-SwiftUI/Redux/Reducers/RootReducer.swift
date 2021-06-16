import SwiftUIRedux

func rootStateReducer(state: RootState, action: Action) -> RootState {
  var newState = state
  switch action {
  case let action as RootActions.SetSelectedTab:
    newState.selectedTab = action.tab
  default:
    break
  }
  return newState
}
