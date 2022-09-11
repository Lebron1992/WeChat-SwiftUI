import ComposableArchitecture

enum SystemAction: Equatable {
  case setErrorMessage(String?)
}

let systemReducer = Reducer<SystemState, SystemAction, Environment> { state, action, _ in
  switch action {
  case let .setErrorMessage(message):
    state.errorMessage = message
    return .none
  }
}
