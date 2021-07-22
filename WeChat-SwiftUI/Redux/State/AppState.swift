import Foundation
import SwiftUIRedux

struct AppState: ReduxState {

  var authState: AuthState
  var contactsState: ContactsState
  var discoverState: DiscoverState
  var meState: MeState
  var rootState: RootState
  var systemState: SystemState

  init() {
    authState = AuthState(signedInUser: nil)

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

    rootState = RootState(selectedTab: .chats)

    systemState = SystemState(showLoading: false)
  }

#if DEBUG
  init(
    authState: AuthState,
    contactsState: ContactsState,
    discoverState: DiscoverState,
    meState: MeState,
    rootState: RootState,
    systemState: SystemState
  ) {
    self.authState = authState
    self.contactsState = contactsState
    self.discoverState = discoverState
    self.meState = meState
    self.rootState = rootState
    self.systemState = systemState
  }
#endif
}

extension AppState: Equatable {
  static func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.authState == rhs.authState &&
    lhs.contactsState == rhs.contactsState &&
    lhs.discoverState == rhs.discoverState &&
    lhs.meState == rhs.meState &&
    lhs.rootState == rhs.rootState &&
    lhs.systemState == rhs.systemState
  }
}

#if DEBUG
extension AppState {
  static var preview: AppState {
    AppState(
      authState: .preview,
      contactsState: .preview,
      discoverState: .preview,
      meState: .preview,
      rootState: .preview,
      systemState: .preview
    )
  }
}
#endif
