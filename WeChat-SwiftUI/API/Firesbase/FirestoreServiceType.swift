import Combine
import ComposableArchitecture

protocol FirestoreServiceType {
  func insert(_ message: Message, to dialog: Dialog) async throws -> Success
  func loadContacts() async throws -> [User]
  func loadDialogs() async throws -> [Dialog]
  func loadMessages(for dialog: Dialog) async throws -> [Message]
  func loadOfficialAccounts() async throws -> [OfficialAccount]
  func loadUserSelf() async throws -> User
  func overrideDialog(_ dialog: Dialog) async throws -> Success
  func overrideUser(_ user: User) async throws
}
