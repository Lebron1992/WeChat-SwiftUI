import XCTest
@testable import WeChat_SwiftUI

private let authStateKey = AppState.ArchiveKeys.authState.rawValue
private let templateAuthState = AuthState(signedInUser: .template)
private let templateDataObj = [authStateKey: templateAuthState.dictionaryRepresentation]

final class AppStateTests: XCTestCase {

  func test_init_withNoArchive() {
    withEnvironment(userDefaults: MockKeyValueStore()) {
      let appState = AppState()
      XCTAssertNil(appState.authState.signedInUser)

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
    userDefaults.set(templateDataObj.data, forKey: .appState)

    withEnvironment(userDefaults: userDefaults) {
      let appState = AppState()
      XCTAssertEqual(appState.authState, templateAuthState)

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
      var appState = AppState()
      appState.authState = templateAuthState
      appState.archive()
      XCTAssertEqual(
        userDefaults.data(forKey: .appState),
        templateDataObj.data
      )

      let newAuthState = AuthState(signedInUser: nil)
      appState.authState = newAuthState
      appState.archive()
      XCTAssertEqual(
        userDefaults.data(forKey: .appState),
        [authStateKey: newAuthState.dictionaryRepresentation].data
      )
    }
  }

  func test_archivePropertiesEqualTo() {
    var pair = twoSameAppStates()
    XCTAssertTrue(pair.0.archivePropertiesEqualTo(pair.1))

    pair = appStatesWithDifferentAuthState()
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
    let appState = AppState()
    XCTAssertEqual(appState.authState, appState[.authState] as? AuthState)
  }

  func test_ArchiveKeys_onlyContainsTheKeyOfAuthState() {
    XCTAssertEqual(AppState.ArchiveKeys.allCases.count, 1)
    XCTAssertEqual(AppState.ArchiveKeys.allCases.first, .authState)
  }

  func test_equals() {
    var pair = twoSameAppStates()
    XCTAssertEqual(pair.0, pair.1)

    pair = appStatesWithDifferentAuthState()
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
    return (AppState(), AppState())
  }

  func appStatesWithDifferentAuthState() -> (AppState, AppState) {
    var state1 = AppState()
    var state2 = AppState()
    state1.authState = AuthState(signedInUser: nil)
    state2.authState = AuthState(signedInUser: .template)
    return (state1, state2)
  }

  func appStatesWithDifferentContactsState() -> (AppState, AppState) {
    var state1 = AppState()
    var state2 = AppState()
    state1.contactsState = ContactsState(
      categories: ContactCategory.allCases,
      contacts: .notRequested,
      officialAccounts: .notRequested
    )
    state2.contactsState = ContactsState(
      categories: [],
      contacts: .isLoading(last: nil, cancelBag: CancelBag()),
      officialAccounts: .isLoading(last: nil, cancelBag: CancelBag())
    )
    return (state1, state2)
  }

  func appStatesWithDifferentDiscoverState() -> (AppState, AppState) {
    var state1 = AppState()
    var state2 = AppState()
    state1.discoverState = DiscoverState(discoverSections: DiscoverSection.allCases)
    state2.discoverState = DiscoverState(discoverSections: [])
    return (state1, state2)
  }

  func appStatesWithDifferentRootState() -> (AppState, AppState) {
    var state1 = AppState()
    var state2 = AppState()
    state1.rootState = RootState(selectedTab: .chats)
    state2.rootState = RootState(selectedTab: .contacts)
    return (state1, state2)
  }

  func appStatesWithDifferentSystemState() -> (AppState, AppState) {
    var state1 = AppState()
    var state2 = AppState()
    state1.systemState = SystemState(errorMessage: nil)
    state2.systemState = SystemState(errorMessage: "error")
    return (state1, state2)
  }
}
