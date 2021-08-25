import Combine

protocol FirestoreServiceType {
  func loadContacts() -> AnyPublisher<[User], Error>
  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error>
  func loadUserSelf() -> AnyPublisher<User, Error>
  func overrideUser(_ user: User) -> AnyPublisher<Void, Error>
}
