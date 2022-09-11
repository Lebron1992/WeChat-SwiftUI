import Combine
import ComposableArchitecture

protocol FirestoreServiceType {
  func insert(_ message: Message, to dialog: Dialog) -> Effect<Success, ErrorEnvelope>
  func loadContacts() -> Effect<[User], ErrorEnvelope>
  func loadDialogs() -> Effect<[Dialog], ErrorEnvelope>
  func loadMessages(for dialog: Dialog) -> Effect<[Message], ErrorEnvelope>
  func loadOfficialAccounts() -> Effect<[OfficialAccount], ErrorEnvelope>
  func loadUserSelf() -> Effect<User, ErrorEnvelope>
  func overrideDialog(_ dialog: Dialog) -> Effect<Success, ErrorEnvelope>
  func overrideUser(_ user: User) -> AnyPublisher<Void, Error>
}
