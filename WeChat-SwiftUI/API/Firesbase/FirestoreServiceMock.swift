import Combine
import ComposableArchitecture

struct FirestoreServiceMock: FirestoreServiceType {

  let insertMessageError: Error?

  let loadContactsResponse: [User]?
  let loadContactsError: Error?

  let loadDialogsResponse: [Dialog]?
  let loadDialogsError: Error?

  let loadMessagesResponse: [Message]?
  let loadMessagesError: Error?

  let loadOfficialAccountsResponse: [OfficialAccount]?
  let loadOfficialAccountsError: Error?

  let loadUserSelfResponse: User?
  let loadUserSelfError: Error?

  let overrideDialogError: Error?
  let overrideUserError: Error?

  init(
    insertMessageError: Error? = nil,
    loadContactsResponse: [User]? = nil,
    loadContactsError: Error? = nil,
    loadDialogsResponse: [Dialog]? = nil,
    loadDialogsError: Error? = nil,
    loadMessagesResponse: [Message]? = nil,
    loadMessagesError: Error? = nil,
    loadOfficialAccountsResponse: [OfficialAccount]? = nil,
    loadOfficialAccountsError: Error? = nil,
    loadUserSelfResponse: User? = nil,
    loadUserSelfError: Error? = nil,
    overrideDialogError: Error? = nil,
    overrideUserError: Error? = nil
  ) {
    self.insertMessageError = insertMessageError

    self.loadContactsResponse = loadContactsResponse
    self.loadContactsError = loadContactsError

    self.loadDialogsResponse = loadDialogsResponse
    self.loadDialogsError = loadDialogsError

    self.loadMessagesResponse = loadMessagesResponse
    self.loadMessagesError = loadMessagesError

    self.loadOfficialAccountsResponse = loadOfficialAccountsResponse
    self.loadOfficialAccountsError = loadOfficialAccountsError

    self.loadUserSelfResponse = loadUserSelfResponse
    self.loadUserSelfError = loadUserSelfError

    self.overrideDialogError = overrideDialogError
    self.overrideUserError = overrideUserError
  }

  func insert(_ message: Message, to dialog: Dialog) async throws -> Success {
    if let error = insertMessageError {
      throw error
    }
    return .init()
  }

  func loadContacts() async throws -> [User] {
    if let error = loadContactsError {
      throw error
    }
    return loadContactsResponse ?? [.template1, .template2]
  }

  func loadDialogs() async throws -> [Dialog] {
    if let error = loadDialogsError {
      throw error
    }
    return loadDialogsResponse ?? [.template1]
  }

  func loadMessages(for dialog: Dialog) async throws -> [Message] {
    if let error = loadMessagesError {
      throw error
    }
    return loadMessagesResponse ?? [.textTemplate1]
  }

  func loadOfficialAccounts() async throws -> [OfficialAccount] {
    if let error = loadOfficialAccountsError {
      throw error
    }
    return loadOfficialAccountsResponse ?? [.template1, .template2]
  }

  func loadUserSelf() async throws -> User {
    if let error = loadUserSelfError {
      throw error
    }
    return loadUserSelfResponse ?? .template1
  }

  func overrideDialog(_ dialog: Dialog) async throws -> Success {
    if let error = overrideDialogError {
      throw error
    }
    return .init()
  }

  func overrideUser(_ user: User) async throws {
    if let error = overrideUserError {
      throw error
    }
  }
}
