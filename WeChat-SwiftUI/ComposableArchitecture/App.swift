import ComposableArchitecture

enum AppAction: Equatable {
  case auth(AuthAction)
  case chats(ChatsAction)
  case contacts(ContactsAction)
  case root(RootAction)
  case system(SystemAction)
}

let appReducer = CombineReducers {
  Scope(state: \AppState.authState, action: /AppAction.auth) {
    AuthReducer()
  }
  Scope(state: \AppState.chatsState, action: /AppAction.chats) {
    ChatsReducer()
  }
  Scope(state: \AppState.contactsState, action: /AppAction.contacts) {
    ContactsReducer()
  }
  Scope(state: \AppState.rootState, action: /AppAction.root) {
    RootReducer()
  }
  Scope(state: \AppState.systemState, action: /AppAction.system) {
    SystemReducer()
  }
  CommonReducer()
}

struct CommonReducer: ReducerProtocol {
  func reduce(into state: inout AppState, action: AppAction) -> EffectTask<AppAction> {
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
}
