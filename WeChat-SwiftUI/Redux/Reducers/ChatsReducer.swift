import SwiftUIRedux

func chatsStateReducer(state: ChatsState, action: Action) -> ChatsState {
  var newState = state
  switch action {
  case let action as ChatsActions.SetDialogs:
    // 为了简便处理，不考虑本地缓存和服务器的数据的差异，直接使用服务器数据
    newState.dialogs = action.dialogs.sorted()

  case let action as ChatsActions.UpdateDialogs:
    newState.updateDialogs(with: action.dialogChanges)

  case let action as ChatsActions.SetMessagesForDialog:
    newState.set(action.messages.sorted(), for: action.dialog)

  case let action as ChatsActions.InsertMessageToDialog:
    newState.insert(action.message, to: action.dialog)

  case let action as ChatsActions.SetMessageStatusInDialog:
    newState.setStatus(action.status, for: action.message, in: action.dialog)

  case let action as ChatsActions.SetDialogLastMessage:
    newState.setLastMessage(action.lastMessage, for: action.dialog)
  default:
    break
  }
  return newState
}
