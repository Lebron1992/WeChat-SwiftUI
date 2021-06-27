import SwiftUIRedux

enum ContactsActions {
  struct LoadContacts: AsyncAction, Equatable {
    func async(dispatch: @escaping Dispatch, state: ReduxState?) {

      let cancelBag = CancelBag()
      let last = (state as? AppState)?.contactsState.contacts.value

      dispatch(SetContacts(contacts: .isLoading(last: last, cancelBag: cancelBag)))

      AppEnvironment.current.apiService
        .loadContacts()
        .sinkToLoadable {
          dispatch(SetContacts(contacts: $0))
        }
        .store(in: cancelBag)
    }
  }

  struct SetContacts: Action, Equatable {
    let contacts: Loadable<[User]>
  }

  struct LoadOfficialAccounts: AsyncAction, Equatable {
    func async(dispatch: @escaping Dispatch, state: ReduxState?) {

      let cancelBag = CancelBag()
      let last = (state as? AppState)?.contactsState.officialAccounts.value

      dispatch(SetOfficialAccounts(accounts: .isLoading(last: last, cancelBag: cancelBag)))

      AppEnvironment.current.apiService
        .loadOfficialAccounts()
        .sinkToLoadable {
          dispatch(SetOfficialAccounts(accounts: $0))
        }
        .store(in: cancelBag)
    }
  }

  struct SetOfficialAccounts: Action, Equatable {
    let accounts: Loadable<[OfficialAccount]>
  }
}
