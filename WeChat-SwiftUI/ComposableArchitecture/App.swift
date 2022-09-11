import ComposableArchitecture

enum AppAction: Equatable {
  case auth(AuthAction)
  case chats(ChatsAction)
  case contacts(ContactsAction)
  case root(RootAction)
  case system(SystemAction)
}

let appReducer: Reducer<AppState, AppAction, Environment> = .combine(
  authReducer.pullback(
    state: \.authState,
    action: /AppAction.auth,
    environment: { $0 }
  ),
  chatsReducer.pullback(
    state: \.chatsState,
    action: /AppAction.chats,
    environment: { $0 }
  ),
  contactsReducer.pullback(
    state: \.contactsState,
    action: /AppAction.contacts,
    environment: { $0 }
  ),
  rootReducer.pullback(
    state: \.rootState,
    action: /AppAction.root,
    environment: { $0 }
  ),
  systemReducer.pullback(
    state: \.systemState,
    action: /AppAction.system,
    environment: { $0 }
  ),
  Reducer { state, action, _ in
    switch action {
      // chats
    case let .chats(.loadDialogsResponse(result)):
      if case let .failure(error) = result {
        state.systemState.errorMessage = error.localizedDescription
      }
      return .none

    case let .chats(.loadMessagesForDialogResponse(_, result)):
      if case let .failure(error) = result {
        state.systemState.errorMessage = error.localizedDescription
      }
      return .none

    case let .chats(.sendMessageInDialogResponse(_, _, result)):
      if case let .failure(error) = result {
        state.systemState.errorMessage = error.localizedDescription
      }
      return .none

    case let .chats(.overrideDialogResponse(_, _, result)):
      if case let .failure(error) = result {
        state.systemState.errorMessage = error.localizedDescription
      }
      return .none

    case let .chats(.uploadImageForMessageInDialogResponse(_, _, result)):
      if case let .failure(error) = result {
        state.systemState.errorMessage = error.localizedDescription
      }
      return .none

    default:
      return .none
    }
  }
)
