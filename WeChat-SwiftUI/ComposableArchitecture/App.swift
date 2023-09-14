import ComposableArchitecture

enum AppAction: Equatable {
  case auth(AuthAction)
  case chats(ChatsAction)
  case contacts(ContactsAction)
  case root(RootAction)
  case system(SystemAction)
}

struct AppReducer: ReducerProtocol {
  var body: some ReducerProtocol<AppState, AppAction> {
    authScope
    chatsScope
    contactsScope
    rootScope
    systemScope
    CommonReducer()
  }
}

let appReducer = AppReducer()

// NOTE: 初始化 `Scope`，一定要先定义变量 `reducer` 再返回，才会编译通过。（可能编译器有问题）

private let authScope = Scope(state: \AppState.authState, action: /AppAction.auth) {
  let reducer = AuthReducer()
  return reducer
}

private let chatsScope = Scope(state: \AppState.chatsState, action: /AppAction.chats) {
  let reducer = ChatsReducer()
  return reducer
}

private let contactsScope = Scope(state: \AppState.contactsState, action: /AppAction.contacts) {
  let reducer = ContactsReducer()
  return reducer
}

private let rootScope = Scope(state: \AppState.rootState, action: /AppAction.root) {
  let reducer = RootReducer()
  return reducer
}

private let systemScope = Scope(state: \AppState.systemState, action: /AppAction.system) {
  let reducer = SystemReducer()
  return reducer
}

private struct CommonReducer: ReducerProtocol {
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
