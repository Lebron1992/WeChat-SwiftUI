import Foundation
import SwiftUIRedux

func appStateReducer(state: AppState, action: Action) -> AppState {
  var newState = state
  newState.authState = authStateReducer(state: state.authState, action: action)
  newState.contactsState = contactsStateReducer(state: state.contactsState, action: action)
  newState.meState = meStateReducer(state: state.meState, action: action)
  newState.rootState = rootStateReducer(state: state.rootState, action: action)
  newState.systemState = systemStateReducer(state: state.systemState, action: action)
  return newState
}
