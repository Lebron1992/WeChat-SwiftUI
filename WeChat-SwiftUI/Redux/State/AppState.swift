import Foundation
import SwiftUIRedux

struct AppState: ReduxState {
  var contactsState: ContactsState
  var rootState: RootState

  init() {
    contactsState = ContactsState(contacts: .notRequested)
    rootState = RootState(selectedTab: .contacts)
  }

  #if DEBUG
  init(
    contactsState: ContactsState,
    rootState: RootState
  ) {
    self.contactsState = contactsState
    self.rootState = rootState
  }
  #endif
}

extension AppState: Equatable {
  static func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.contactsState == rhs.contactsState &&
      lhs.rootState == rhs.rootState
  }
}

#if DEBUG
extension AppState {
  static var preview: AppState {
    AppState(
      contactsState: .preview,
      rootState: .preview
    )
  }
}
#endif
