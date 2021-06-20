import Foundation

struct ContactsState {
  var contacts: Loadable<[User]>
}

extension ContactsState: Equatable {
  static func == (lhs: ContactsState, rhs: ContactsState) -> Bool {
    lhs.contacts == rhs.contacts
  }
}

#if DEBUG
extension ContactsState {
  static var preview: ContactsState {
    ContactsState(
      contacts: .notRequested
    )
  }
}
#endif
