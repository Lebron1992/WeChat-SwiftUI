import Foundation
import SwiftUIRedux

func appStateReducer(state: AppState, action: Action) -> AppState {
  var newState = state
  newState.contactsState = contactsStateReducer(state: state.contactsState, action: action)
  newState.meState = meStateReducer(state: state.meState, action: action)
  newState.rootState = rootStateReducer(state: state.rootState, action: action)
  return newState
}
