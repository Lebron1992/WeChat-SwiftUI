import Combine
import FirebaseFirestore

struct FirestoreService: FirestoreServiceType {

  private let usersCollection: CollectionReference

  init() {
    let database = Firestore.firestore()
    usersCollection = database.collection("users")
  }

  func loadUserSelf() -> AnyPublisher<User, Error> {
    let userId = AppEnvironment.current.currentUser?.id ?? ""

    return Future { promise in
      usersCollection
        .document(userId)
        .getDocument { snapshot, error in

          if let err = error {
            promise(Result.failure(err))

          } else if let data = snapshot?.data(), let user: User = tryDecode(data) {
            promise(Result.success(user))

          } else {
            let error = NSError(
              domain: "",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Can not decode user from snapshot"]
            )
            promise(Result.failure(error as Error))
          }
        }
    }
    .eraseToAnyPublisher()
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
