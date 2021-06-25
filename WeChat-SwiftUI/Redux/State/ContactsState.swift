import Foundation

struct ContactsState {
  var categories: [ContactCategory]
  var contacts: Loadable<[User]>
  var searchText: String
}

extension ContactsState: Equatable {
  static func == (lhs: ContactsState, rhs: ContactsState) -> Bool {
    lhs.categories == rhs.categories &&
    lhs.contacts == rhs.contacts &&
    lhs.searchText == lhs.searchText
  }
}

#if DEBUG
extension ContactsState {
  static var preview: ContactsState {
    ContactsState(
      categories: ContactCategory.allCases,
      contacts: .notRequested,
      searchText: ""
    )
  }
}
#endif
