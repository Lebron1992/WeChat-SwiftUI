import Foundation

struct ContactsState {
  var contacts: Loadable<[User]>
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
