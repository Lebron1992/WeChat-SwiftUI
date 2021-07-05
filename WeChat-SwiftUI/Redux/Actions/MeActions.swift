import SwiftUIRedux

enum MeActions {

  struct LoadUserSelf: AsyncAction, Equatable {
    func async(dispatch: @escaping Dispatch, state: ReduxState?) {

      let cancelBag = CancelBag()
      let last = (state as? AppState)?.meState.userSelf.value

      dispatch(SetUserSelf(userSelf: .isLoading(last: last, cancelBag: cancelBag)))

      AppEnvironment.current.apiService
        .loadUserSelf()
        .sinkToLoadable {
          dispatch(SetUserSelf(userSelf: $0))
        }
        .store(in: cancelBag)
    }
  }

  struct SetUserSelf: Action, Equatable {
    let userSelf: Loadable<User>
  }
}
