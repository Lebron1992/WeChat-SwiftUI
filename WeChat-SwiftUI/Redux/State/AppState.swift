import Foundation
import SwiftUIRedux

private let appStateStorageKey = "com.WeChat-SwiftUI.AppState"
private var archiveURL: URL!

struct AppState: ReduxState {

  var authState = AuthState(signedInUser: nil)

  var contactsState = ContactsState(
    categories: ContactCategory.allCases,
    contacts: .notRequested,
    officialAccounts: .notRequested
  )

  var discoverState = DiscoverState(discoverSections: DiscoverSection.allCases)

  var rootState = RootState(selectedTab: .chats)

  var systemState = SystemState(showLoading: false)

  init() {
    guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("Couldn't get document directory")
    }
    archiveURL = docDir.appendingPathComponent("AppState")

    guard let data = try? Data(contentsOf: archiveURL),
          let dataObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
          }

    for key in ArchiveKeys.allCases {
      let json = dataObj[key.rawValue] as? [String: Any] ?? [:]
      switch key {
      case .authState:
        if let state: AuthState = tryDecode(json) {
          authState = state
        } else {
          authState = AuthState(signedInUser: nil)
        }
      }
    }
  }

  // MARK: - Archive

  func archive() {
    var dataObj: [String: Any] = [:]

    for key in ArchiveKeys.allCases {
      switch key {
      case .authState:
        dataObj[key.rawValue] = authState.dictionaryRepresentation
      }
    }

    guard let data = try? JSONSerialization.data(withJSONObject: dataObj) else {
      return
    }

    do {
      try data.write(to: archiveURL)
    } catch {
      print("Error saving AppState: \(error)")
    }
  }

  func archivePropertiesEqualTo(_ another: AppState) -> Bool {
    var isEqual = true

    // swiftlint:disable force_cast
    for key in ArchiveKeys.allCases {
      switch key {
      case .authState:
        isEqual = (self[key] as! AuthState) == (another[key] as! AuthState)
      }
      if isEqual == false {
        break
      }
    }

    return isEqual
  }

  subscript(key: ArchiveKeys) -> Any {
    switch key {
    case .authState:
      return authState
    }
  }

#if DEBUG
  init(
    authState: AuthState,
    contactsState: ContactsState,
    discoverState: DiscoverState,
    rootState: RootState,
    systemState: SystemState
  ) {
    self.authState = authState
    self.contactsState = contactsState
    self.discoverState = discoverState
    self.rootState = rootState
    self.systemState = systemState
  }
#endif
}

extension AppState {
  enum ArchiveKeys: String, CaseIterable {
    case authState
  }
}

extension AppState: Equatable {
  static func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.authState == rhs.authState &&
    lhs.contactsState == rhs.contactsState &&
    lhs.discoverState == rhs.discoverState &&
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
      rootState: .preview,
      systemState: .preview
    )
  }
}
#endif
