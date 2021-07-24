import Combine
import FirebaseFirestore

struct FirestoreService: FirestoreServiceType {

  private let database: Firestore
  private let usersCollection: CollectionReference

  init() {
    database = Firestore.firestore()
    usersCollection = database.collection("users")
  }

  func overrideUser(_ user: User) -> AnyPublisher<Void, Error> {
    Future { promise in
      usersCollection
        .document(user.id)
        .setData(user.dictionaryRepresentation ?? [:]) { error in
          if let e = error {
            promise(Result.failure(e))
          } else {
            promise(Result.success(()))
          }
        }
    }
    .eraseToAnyPublisher()
  }
}
