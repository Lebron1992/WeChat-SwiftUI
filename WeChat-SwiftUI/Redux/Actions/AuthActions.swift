import SwiftUIRedux

enum AuthActions {
  private static let cancelBag = CancelBag()

  struct LoadUserSelf: AsyncAction, Equatable {
    func async(dispatch: @escaping Dispatch, state: ReduxState?) {
      AppEnvironment.current.firestoreService
        .loadUserSelf()
        .sinkToResultForUI { result in
          if case .success(let user) = result {
            dispatch(SetSignedInUser(user: user))
          }
        }
        .store(in: cancelBag)
    }

    static func == (lhs: AuthActions.LoadUserSelf, rhs: AuthActions.LoadUserSelf) -> Bool {
      true
    }
  }

  struct SetSignedInUser: Action, Equatable {
    let user: User?
  }
}
