import Foundation
import SwiftUIRedux

struct AppState: ReduxState, Equatable {

  var authState = AuthState(signedInUser: nil)

  var chatsState = ChatsState(dialogs: [], dialogMessages: [])

  var contactsState = ContactsState(
    categories: ContactCategory.allCases,
    contacts: .notRequested,
    officialAccounts: .notRequested
  )

  var discoverState = DiscoverState(discoverSections: DiscoverSection.allCases)

  var rootState = RootState(selectedTab: .chats)

  var systemState = SystemState(errorMessage: nil)

  init() {
    guard let data = AppEnvironment.current.userDefaults.data(forKey: .appState),
          let dataObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
      return
    }

    for key in ArchiveKeys.allCases {
      let json = dataObj[key.rawValue] as? [String: Any] ?? [:]
      switch key {
      case .authState:
        if let state: AuthState = tryDecode(json) {
          authState = state
        }
      case .chatsState:
        if let state: ChatsState = tryDecode(json) {
          chatsState = state
        }
      }
    }
  }
}

// MARK: - Archive
extension AppState {
  enum ArchiveKeys: String, CaseIterable {
    case authState
    case chatsState
  }

  subscript(key: ArchiveKeys) -> Any {
    switch key {
    case .authState:
      return authState
    case .chatsState:
      return chatsState
    }
  }

  func archive() {
    var dataObj: [String: Any] = [:]

    for key in ArchiveKeys.allCases {
      switch key {
      case .authState:
        dataObj[key.rawValue] = authState.dictionaryRepresentation
      case .chatsState:
        dataObj[key.rawValue] = chatsState.dictionaryRepresentation
      }
    }

    AppEnvironment.current.userDefaults.set(dataObj.data, forKey: .appState)
    AppEnvironment.current.userDefaults.synchronize()
  }

  func archivePropertiesEqualTo(_ another: AppState) -> Bool {
    var isEqual = true

    // swiftlint:disable force_cast
    for key in ArchiveKeys.allCases {
      switch key {
      case .authState:
        isEqual = (self[key] as! AuthState) == (another[key] as! AuthState)
      case .chatsState:
        isEqual = (self[key] as! ChatsState) == (another[key] as! ChatsState)
      }
      if isEqual == false {
        break
      }
    }

    return isEqual
  }
}

// MARK: - Preview

#if DEBUG
extension AppState {
  init(
    authState: AuthState = .preview,
    chatsState: ChatsState = .preview,
    contactsState: ContactsState = .preview,
    discoverState: DiscoverState = .preview,
    rootState: RootState = .preview,
    systemState: SystemState = .preview
  ) {
    self.authState = authState
    self.chatsState = chatsState
    self.contactsState = contactsState
    self.discoverState = discoverState
    self.rootState = rootState
    self.systemState = systemState
  }

  static var preview: AppState {
    AppState(
      authState: .preview,
      chatsState: .preview,
      contactsState: .preview,
      discoverState: .preview,
      rootState: .preview,
      systemState: .preview
    )
  }
}
#endif
