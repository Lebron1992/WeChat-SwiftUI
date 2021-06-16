import Foundation
import SwiftUIRedux

func appStateReducer(state: AppState, action: Action) -> AppState {
  var newState = state
  newState.rootState = rootStateReducer(state: state.rootState, action: action)
  return newState
}
