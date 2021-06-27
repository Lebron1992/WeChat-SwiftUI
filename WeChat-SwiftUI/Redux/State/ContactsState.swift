import Foundation

struct ContactsState {
  var categories: [ContactCategory]
  var contacts: Loadable<[User]>
  var officialAccounts: Loadable<[OfficialAccount]>
}

extension ContactsState: Equatable {
  static func == (lhs: ContactsState, rhs: ContactsState) -> Bool {
    lhs.categories == rhs.categories &&
    lhs.contacts == rhs.contacts &&
    lhs.officialAccounts == lhs.officialAccounts
  }
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
