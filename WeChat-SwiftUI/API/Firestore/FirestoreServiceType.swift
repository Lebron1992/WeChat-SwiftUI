import Combine

protocol FirestoreServiceType {
  func loadUserSelf() -> AnyPublisher<User, Error>
  func overrideUser(_ user: User) -> AnyPublisher<Void, Error>
}
