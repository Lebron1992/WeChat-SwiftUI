import Foundation
import SwiftUIRedux

struct AppState: ReduxState {
  var contactsState: ContactsState
  var discoverState: DiscoverState
  var meState: MeState
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
    meState = MeState(
      userSelf: .notRequested
    )
    rootState = RootState(selectedTab: .me)
  }

  #if DEBUG
  init(
    contactsState: ContactsState,
    discoverState: DiscoverState,
    meState: MeState,
    rootState: RootState
  ) {
    self.contactsState = contactsState
    self.discoverState = discoverState
    self.meState = meState
    self.rootState = rootState
  }
  #endif
}

extension AppState: Equatable {
  static func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.contactsState == rhs.contactsState &&
      lhs.discoverState == rhs.discoverState &&
      lhs.meState == rhs.meState &&
      lhs.rootState == rhs.rootState
  }
}

#if DEBUG
extension AppState {
  static var preview: AppState {
    AppState(
      contactsState: .preview,
      discoverState: .preview,
      meState: .preview,
      rootState: .preview
    )
  }
}
#endif
