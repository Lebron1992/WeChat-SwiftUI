import Combine

protocol FirestoreServiceType {
  func overrideUser(_ user: User) -> AnyPublisher<Void, Error>
}
