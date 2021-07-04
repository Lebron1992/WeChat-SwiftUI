import Foundation
import SwiftUIRedux

struct AppState: ReduxState {
  var contactsState: ContactsState
  var discoverState: DiscoverState
  var rootState: RootState

  init() {
    contactsState = ContactsState(
      categories: ContactCategory.allCases,
      contacts: .notRequested,
      officialAccounts: .notRequested
    )
    discoverState = DiscoverState(
      discoverSections: DiscoverSection.allCases
    )
    rootState = RootState(selectedTab: .contacts)
  }

  #if DEBUG
  init(
    contactsState: ContactsState,
    discoverState: DiscoverState,
    rootState: RootState
  ) {
    self.contactsState = contactsState
    self.discoverState = discoverState
    self.rootState = rootState
  }
  #endif
}

extension AppState: Equatable {
  static func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.contactsState == rhs.contactsState &&
      lhs.discoverState == rhs.discoverState &&
      lhs.rootState == rhs.rootState
  }
}

#if DEBUG
extension AppState {
  static var preview: AppState {
    AppState(
      contactsState: .preview,
      discoverState: .preview,
      rootState: .preview
    )
  }
}
#endif
