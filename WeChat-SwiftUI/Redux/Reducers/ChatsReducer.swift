import SwiftUIRedux

func chatsStateReducer(state: ChatsState, action: Action) -> ChatsState {
  var newState = state
  switch action {
  case let action as ChatsActions.InsertMessageToDialog:
    newState.insert(action.message, to: action.dialog)

  case let action as ChatsActions.SetMessageStatusInDialog:
    newState.setStatus(action.status, for: action.message, in: action.dialog)

  case let action as ChatsActions.SetDialogIsSavedToServer:
    newState.setIsSavedToServer(action.isSaved, for: action.dialog)
  default:
    break
  }
  return newState
}
