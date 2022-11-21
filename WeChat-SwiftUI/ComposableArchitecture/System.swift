import ComposableArchitecture

enum SystemAction: Equatable {
  case setErrorMessage(String?)
}

struct SystemReducer: ReducerProtocol {
  func reduce(into state: inout SystemState, action: SystemAction) -> EffectTask<SystemAction> {
    switch action {
    case let .setErrorMessage(message):
      state.errorMessage = message
      return .none
    }
  }
}
