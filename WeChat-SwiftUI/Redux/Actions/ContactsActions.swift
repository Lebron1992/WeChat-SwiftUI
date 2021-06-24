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

  struct SetSearchText: Action, Equatable {
    let searchText: String
  }
}
