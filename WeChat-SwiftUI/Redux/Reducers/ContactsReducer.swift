import SwiftUIRedux

func contactsStateReducer(state: ContactsState, action: Action) -> ContactsState {
  var newState = state
  switch action {
  case let action as ContactsActions.SetContacts:
    newState.contacts = action.contacts
  case let action as ContactsActions.SetSearchText:
    newState.searchText = action.searchText
  default:
    break
  }
  return newState
}
