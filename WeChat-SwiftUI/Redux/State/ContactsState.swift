import Foundation

struct ContactsState: Equatable {
  var categories: [ContactCategory]
  var contacts: Loadable<[User]>
  var officialAccounts: Loadable<[OfficialAccount]>
}

#if DEBUG
extension ContactsState {
  static var preview: ContactsState {
    ContactsState(
      categories: ContactCategory.allCases,
      contacts: .notRequested,
      officialAccounts: .notRequested
    )
  }
}
#endif
