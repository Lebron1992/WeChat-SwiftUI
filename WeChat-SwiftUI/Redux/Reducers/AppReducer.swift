import Foundation
import SwiftUIRedux

func appStateReducer(state: AppState, action: Action) -> AppState {
  var newState = state
  newState.rootState = rootStateReducer(state: state.rootState, action: action)
  newState.contactsState = contactsStateReducer(state: state.contactsState, action: action)
  return newState
}
