import XCTest
@testable import WeChat_SwiftUI

private let authStateKey = AppState.ArchiveKeys.authState.rawValue
private let templateAuthState = AuthState(signedInUser: .template1)

private let chatsStateKey = AppState.ArchiveKeys.chatsState.rawValue
private let templateChatsState = ChatsState(dialogs: [.template1], dialogMessages: [.template1])

private let templateDataJSON: [String: Any] = [
  authStateKey: templateAuthState.dictionaryRepresentation as Any,
  chatsStateKey: templateChatsState.dictionaryRepresentation as Any
]

final class AppStateTests: XCTestCase {

  func test_persistenceKey() {
    XCTAssertEqual(
      "com.WeChat-SwiftUI.appState", KeyValueStoreKey.appState.key,
      "测试失败意味着用户数据丢失。"
    )
  }

  func test_init_withNoArchive() {
    withEnvironment(userDefaults: MockKeyValueStore()) {
      let appState = AppState()
      XCTAssertNil(appState.authState.signedInUser)
      XCTAssertTrue(appState.chatsState.dialogs.isEmpty)

      XCTAssertEqual(appState.contactsState.categories, ContactCategory.allCases)
      XCTAssertEqual(appState.contactsState.contacts, .notRequested)
      XCTAssertEqual(appState.contactsState.officialAccounts, .notRequested)

      XCTAssertEqual(appState.discoverState.discoverSections, DiscoverSection.allCases)

      XCTAssertEqual(appState.rootState.selectedTab, .chats)

      XCTAssertNil(appState.systemState.errorMessage)
    }
  }

  func test_init_restoredArchive() {

    let userDefaults = MockKeyValueStore()
    userDefaults.set(templateDataJSON.data, forKey: .appState)

    withEnvironment(userDefaults: userDefaults) {
      let appState = AppState()
      XCTAssertEqual(appState.authState, templateAuthState)
      XCTAssertEqual(appState.chatsState, templateChatsState)

      XCTAssertEqual(appState.contactsState.categories, ContactCategory.allCases)
      XCTAssertEqual(appState.contactsState.contacts, .notRequested)
      XCTAssertEqual(appState.contactsState.officialAccounts, .notRequested)

      XCTAssertEqual(appState.discoverState.discoverSections, DiscoverSection.allCases)

      XCTAssertEqual(appState.rootState.selectedTab, .chats)

      XCTAssertNil(appState.systemState.errorMessage)
    }
  }

  func test_archive() {
    let userDefaults = MockKeyValueStore()
    withEnvironment(userDefaults: userDefaults) {
      var appState: AppState = .preview
      appState.authState = templateAuthState
      appState.chatsState = templateChatsState
      appState.archive()
      XCTAssertEqual(
        userDefaults.data(forKey: .appState)?.count,
        templateDataJSON.data?.count
      )

      let newAuthState = AuthState(signedInUser: nil)
      let newChatsState = ChatsState(dialogs: [], dialogMessages: [])
      appState.authState = newAuthState
      appState.chatsState = newChatsState
      appState.archive()

      let newDataJSON: [String: Any] = [
        authStateKey: newAuthState.dictionaryRepresentation as Any,
        chatsStateKey: newChatsState.dictionaryRepresentation  as Any
      ]
      XCTAssertEqual(
        userDefaults.data(forKey: .appState),
        newDataJSON.data
      )
    }
  }

  func test_archivePropertiesEqualTo() {
    var pair = twoSameAppStates()
    XCTAssertTrue(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentAuthState()
    XCTAssertFalse(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentChatsState()
    XCTAssertFalse(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentContactsState()
    XCTAssertTrue(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentDiscoverState()
    XCTAssertTrue(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentRootState()
    XCTAssertTrue(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentSystemState()
    XCTAssertTrue(pair.0.archivePropertiesEqualTo(pair.1))
  }

  func test_subscriptArchiveKeys() {
    let appState: AppState = .preview
    XCTAssertEqual(appState.authState, appState[.authState] as? AuthState)
    XCTAssertEqual(appState.chatsState, appState[.chatsState] as? ChatsState)
  }

  func test_equals() {
    var pair = twoSameAppStates()
    XCTAssertEqual(pair.0, pair.1)

    pair = appStatesWithDifferentAuthState()
    XCTAssertNotEqual(pair.0, pair.1)

    pair = appStatesWithDifferentChatsState()
    XCTAssertNotEqual(pair.0, pair.1)

    pair = appStatesWithDifferentContactsState()
    XCTAssertNotEqual(pair.0, pair.1)

    pair = appStatesWithDifferentDiscoverState()
    XCTAssertNotEqual(pair.0, pair.1)

    pair = appStatesWithDifferentRootState()
    XCTAssertNotEqual(pair.0, pair.1)

    pair = appStatesWithDifferentSystemState()
    XCTAssertNotEqual(pair.0, pair.1)
  }
}

private extension AppStateTests {
  func twoSameAppStates() -> (AppState, AppState) {
    return (.preview, .preview)
  }

  func appStatesWithDifferentAuthState() -> (AppState, AppState) {
    var state1: AppState = .preview
    var state2: AppState = .preview
    state1.authState = AuthState(signedInUser: nil)
    state2.authState = AuthState(signedInUser: .template1)
    return (state1, state2)
  }

  func appStatesWithDifferentChatsState() -> (AppState, AppState) {
    var state1: AppState = .preview
    var state2: AppState = .preview
    state1.chatsState = ChatsState(dialogs: [.template2], dialogMessages: [.template1])
    state2.chatsState = ChatsState(dialogs: [.template1, .template2], dialogMessages: [.template2])
    return (state1, state2)
  }

  func appStatesWithDifferentContactsState() -> (AppState, AppState) {
    var state1: AppState = .preview
    var state2: AppState = .preview
    state1.contactsState = ContactsState(
      categories: ContactCategory.allCases,
      contacts: .notRequested,
      officialAccounts: .notRequested
    )
    state2.contactsState = ContactsState(
      categories: [],
      contacts: .isLoading(last: nil),
      officialAccounts: .isLoading(last: nil)
    )
    return (state1, state2)
  }

  func appStatesWithDifferentDiscoverState() -> (AppState, AppState) {
    var state1: AppState = .preview
    var state2: AppState = .preview
    state1.discoverState = DiscoverState(discoverSections: DiscoverSection.allCases)
    state2.discoverState = DiscoverState(discoverSections: [])
    return (state1, state2)
  }

  func appStatesWithDifferentRootState() -> (AppState, AppState) {
    var state1: AppState = .preview
    var state2: AppState = .preview
    state1.rootState = RootState(selectedTab: .chats)
    state2.rootState = RootState(selectedTab: .contacts)
    return (state1, state2)
  }

  func appStatesWithDifferentSystemState() -> (AppState, AppState) {
    var state1: AppState = .preview
    var state2: AppState = .preview
    state1.systemState = SystemState(errorMessage: nil)
    state2.systemState = SystemState(errorMessage: "error")
    return (state1, state2)
  }
}
