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

  func insert(_ message: Message, to dialog: Dialog) -> Effect<Success, ErrorEnvelope> {
    if let error = insertMessageError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: .init())
  }

  func loadContacts() -> Effect<[User], ErrorEnvelope> {
    if let error = loadContactsError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: loadContactsResponse ?? [.template1, .template2])
  }

  func loadDialogs() -> Effect<[Dialog], ErrorEnvelope> {
    if let error = loadDialogsError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: loadDialogsResponse ?? [.template1])
  }

  func loadMessages(for dialog: Dialog) -> Effect<[Message], ErrorEnvelope> {
    if let error = loadMessagesError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: loadMessagesResponse ?? [.textTemplate1])
  }

  func loadOfficialAccounts() -> Effect<[OfficialAccount], ErrorEnvelope> {
    if let error = loadOfficialAccountsError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: loadOfficialAccountsResponse ?? [.template1, .template2])
  }

  func loadUserSelf() -> Effect<User, ErrorEnvelope> {
    if let error = loadUserSelfError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: loadUserSelfResponse ?? .template1)
  }

  func overrideDialog(_ dialog: Dialog) -> Effect<Success, ErrorEnvelope> {
    if let error = overrideDialogError {
      return .init(error: error.toEnvelope())
    }
    return .init(value: .init())
  }

  func overrideUser(_ user: User) -> AnyPublisher<Void, Error> {
    if let error = overrideUserError {
      return .publisher(failure: error)
    }
    return .publisher(output: ())
  }
}
