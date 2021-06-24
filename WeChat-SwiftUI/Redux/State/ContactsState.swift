import Foundation

struct ContactsState {
  var contacts: Loadable<[User]>
  var searchText: String
}

extension ContactsState: Equatable {
  static func == (lhs: ContactsState, rhs: ContactsState) -> Bool {
    lhs.contacts == rhs.contacts &&
    lhs.searchText == lhs.searchText
  }
}

#if DEBUG
extension ContactsState {
  static var preview: ContactsState {
    ContactsState(
      contacts: .notRequested,
      searchText: ""
    )
  }
}
#endif
