@testable import WeChat_SwiftUI
import XCTest
import ComposableArchitecture

@MainActor
final class ContactsTests: XCTestCase {

  func test_loadContacts_success() async {
    let contacts: [User] = [.template1, .template2]
    let mockService = FirestoreServiceMock(loadContactsResponse: contacts)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(contactsState: .preview),
        reducer: appReducer
      )

      await store.send(.contacts(.loadContacts)) {
        $0.contactsState.contacts = .isLoading(last: nil)
      }

      await store.receive(.contacts(.loadContactsResponse(.success(contacts)))) {
        $0.contactsState.contacts = .loaded(contacts)
      }
    }
  }

  func test_loadContacts_failed() async {
    let error = NSError.commonError(description: "failed to load contacts")
    let mockService = FirestoreServiceMock(loadContactsError: error)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(authState: .preview),
        reducer: appReducer
      )

      await store.send(.contacts(.loadContacts)) {
        $0.contactsState.contacts = .isLoading(last: nil)
      }

      await store.receive(.contacts(.loadContactsResponse(.failure(error)))) {
        $0.contactsState.contacts = .failed(error)
      }
    }
  }

  func test_loadOfficialAccounts_success() async {
    let accounts: [OfficialAccount] = [.template1, .template2]
    let mockService = FirestoreServiceMock(loadOfficialAccountsResponse: accounts)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(contactsState: .preview),
        reducer: appReducer
      )

      await store.send(.contacts(.loadOfficialAccounts)) {
        $0.contactsState.officialAccounts = .isLoading(last: nil)
      }

      await store.receive(.contacts(.loadOfficialAccountsResponse(.success(accounts)))) {
        $0.contactsState.officialAccounts = .loaded(accounts)
      }
    }
  }

  func test_loadOfficialAccounts_failed() async {
    let error = NSError.commonError(description: "failed to load official accounts")
    let mockService = FirestoreServiceMock(loadOfficialAccountsError: error)

    await withEnvironmentAsync(firestoreService: mockService) {
      let store = TestStore(
        initialState: AppState(authState: .preview),
        reducer: appReducer
      )

      await store.send(.contacts(.loadOfficialAccounts)) {
        $0.contactsState.officialAccounts = .isLoading(last: nil)
      }

      await store.receive(.contacts(.loadOfficialAccountsResponse(.failure(error)))) {
        $0.contactsState.officialAccounts = .failed(error)
      }
    }
  }
}
