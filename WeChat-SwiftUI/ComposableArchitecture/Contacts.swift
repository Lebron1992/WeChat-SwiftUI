import ComposableArchitecture

enum ContactsAction: Equatable {
  case loadContacts
  case loadContactsResponse(Result<[User], ErrorEnvelope>)

  case loadOfficialAccounts
  case loadOfficialAccountsResponse(Result<[OfficialAccount], ErrorEnvelope>)
}

let contactsReducer = Reducer<ContactsState, ContactsAction, Environment> { state, action, _ in
  switch action {
  case .loadContacts:
    struct LoadContactsId: Hashable {}
    state.contacts = .isLoading(last: state.contacts.value)
    return AppEnvironment.current.firestoreService
      .loadContacts()
      .catchToEffect(ContactsAction.loadContactsResponse)
      .cancellable(id: LoadContactsId(), cancelInFlight: true)

  case let .loadContactsResponse(result):
    switch result {
    case let .success(users):
      state.contacts = .loaded(users)
    case let .failure(error):
      state.contacts = .failed(error)
    }
    return .none

  case .loadOfficialAccounts:
    struct LoadOfficialAccountsId: Hashable {}
    state.officialAccounts = .isLoading(last: state.officialAccounts.value)
    return AppEnvironment.current.firestoreService
      .loadOfficialAccounts()
      .catchToEffect(ContactsAction.loadOfficialAccountsResponse)
      .cancellable(id: LoadOfficialAccountsId(), cancelInFlight: true)

  case let .loadOfficialAccountsResponse(result):
    switch result {
    case let .success(accounts):
      state.officialAccounts = .loaded(accounts)
    case let .failure(error):
      state.officialAccounts = .failed(error)
    }
    return .none
  }
}
