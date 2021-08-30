import Combine

protocol FirestoreServiceType {
  func insert(_ message: Message, to dialog: Dialog) -> AnyPublisher<Void, Error>
  func loadContacts() -> AnyPublisher<[User], Error>
  func loadDialogs() -> AnyPublisher<[Dialog], Error>
  func loadMessages(for dialog: Dialog) -> AnyPublisher<[Message], Error>
  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error>
  func loadUserSelf() -> AnyPublisher<User, Error>
  func overrideDialog(_ dialog: Dialog) -> AnyPublisher<Void, Error>
  func overrideUser(_ user: User) -> AnyPublisher<Void, Error>
}
