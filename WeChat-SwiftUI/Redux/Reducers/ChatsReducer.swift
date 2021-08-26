import SwiftUIRedux

func chatsStateReducer(state: ChatsState, action: Action) -> ChatsState {
  var newState = state
  switch action {
  case let action as ChatsActions.AppendMessageToDialog:

    let newDialog = newState.dialogs
      .element(matching: action.dialog)
      .append(action.message)

    if let index = newState.dialogs.index(matching: newDialog) {
      newState.dialogs[index] = newDialog
    } else {
      newState.dialogs.append(newDialog)
    }

    newState.dialogs = newState.dialogs.sorted()
  default:
    break
  }
  return newState
}
