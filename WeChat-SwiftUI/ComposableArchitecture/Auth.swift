import ComposableArchitecture

enum AuthAction: Equatable {
  case loadUserSelf
  case loadUserSelfResponse(Result<User, ErrorEnvelope>)
  case setSignedInUser(User?)
}

let authReducer = Reducer<AuthState, AuthAction, Environment> { state, action, _ in
  switch action {
  case .loadUserSelf:
    struct LoadUserSelfId: Hashable {}
    return AppEnvironment.current.firestoreService
      .loadUserSelf()
      .catchToEffect(AuthAction.loadUserSelfResponse)
      .cancellable(id: LoadUserSelfId(), cancelInFlight: true)

  case let .loadUserSelfResponse(result):
    if let user = try? result.get() {
      state.signedInUser = user
      AppEnvironment.updateCurrentUser(user)
    }
    return .none

  case let .setSignedInUser(user):
    state.signedInUser = user

    if let user = user {
      // token is unnecessary for firestoreService, but we set it to make AppEnvironment works
      let tokenEnvelope = AccessTokenEnvelope(accessToken: "deadbeef", user: user)
      AppEnvironment.login(tokenEnvelope)
    } else {
      AppEnvironment.logout()
    }

    return .none
  }
}
