import ComposableArchitecture

enum ContactsAction: Equatable {
  case loadContacts
  case loadContactsResponse(TaskResult<[User]>)

  case loadOfficialAccounts
  case loadOfficialAccountsResponse(TaskResult<[OfficialAccount]>)
}

struct ContactsReducer: ReducerProtocol {
  func reduce(into state: inout ContactsState, action: ContactsAction) -> EffectTask<ContactsAction> {
    switch action {
    case .loadContacts:
      struct LoadContactsId: Hashable {}
      state.contacts = .isLoading(last: state.contacts.value)
      return .task {
       await .loadContactsResponse(TaskResult {
          try await AppEnvironment.current.firestoreService.loadContacts()
        })
      }
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
      return .task {
        await .loadOfficialAccountsResponse(TaskResult {
          try await AppEnvironment.current.firestoreService.loadOfficialAccounts()
        })
      }
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
}
