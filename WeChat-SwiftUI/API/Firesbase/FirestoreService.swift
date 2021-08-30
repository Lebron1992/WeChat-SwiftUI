import Combine
import Foundation
import FirebaseFirestore

struct FirestoreService: FirestoreServiceType {

  private let dialogsCollection: CollectionReference
  private let officialAccountsCollection: CollectionReference
  private let usersCollection: CollectionReference

  init() {
    let database = Firestore.firestore()
    dialogsCollection = database.collection("dialogs")
    officialAccountsCollection = database.collection("official-accounts")
    usersCollection = database.collection("users")
  }

  func insert(_ message: Message, to dialog: Dialog) -> AnyPublisher<Void, Error> {
    Future { promise in
      dialogsCollection
        .document(dialog.id)
        .collection("messages")
        .document(message.id)
        .setData(message.dictionaryRepresentation ?? [:]) { error in
          if let e = error {
            promise(Result.failure(e))
          } else {
            promise(Result.success(()))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func loadContacts() -> AnyPublisher<[User], Error> {
    Future { promise in
      usersCollection
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err))

          } else if let users: [User] = decodeModels(snapshot?.documents) {
            promise(Result.success(users))

          } else {
            let error = NSError.commonError(description: "Can not decode [User] from snapshot")
            promise(Result.failure(error as Error))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func loadDialogs() -> AnyPublisher<[Dialog], Error> {
    Future { promise in
      dialogsCollection
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err))

          } else if let dialogs: [Dialog] = decodeModels(snapshot?.documents) {
            promise(Result.success(dialogs))

          } else {
            let error = NSError.commonError(description: "Can not decode [Dialog] from snapshot")
            promise(Result.failure(error))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func loadMessages(for dialog: Dialog) -> AnyPublisher<[Message], Error> {
    Future { promise in
      dialogsCollection
        .document(dialog.id)
        .collection("messages")
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err))

          } else if let messages: [Message] = decodeModels(snapshot?.documents) {
            promise(Result.success(messages))

          } else {
            let error = NSError.commonError(description: "Can not decode [Message] from snapshot")
            promise(Result.failure(error as Error))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func loadOfficialAccounts() -> AnyPublisher<[OfficialAccount], Error> {
    Future { promise in
      officialAccountsCollection
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err))

          } else if let accounts: [OfficialAccount] = decodeModels(snapshot?.documents) {
            promise(Result.success(accounts))

          } else {
            let error = NSError.commonError(description: "Can not decode [OfficialAccount] from snapshot")
            promise(Result.failure(error as Error))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func loadUserSelf() -> AnyPublisher<User, Error> {

    guard let userId = AppEnvironment.current.currentUser?.id else {
      let error = NSError.commonError(description: "currentUser is nil")
      return .publisher(failure: error)
    }

    return Future { promise in
      usersCollection
        .document(userId)
        .getDocument { snapshot, error in

          if let err = error {
            promise(Result.failure(err))

          } else if let user: User = decodeModel(snapshot) {
            promise(Result.success(user))

          } else {
            let error = NSError.commonError(description: "Can not decode user from snapshot")
            promise(Result.failure(error as Error))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func overrideDialog(_ dialog: Dialog) -> AnyPublisher<Void, Error> {
    Future { promise in
      dialogsCollection
        .document(dialog.id)
        .setData(dialog.dictionaryRepresentation ?? [:]) { error in
          if let e = error {
            promise(Result.failure(e))
          } else {
            promise(Result.success(()))
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

// MARK: - Helper Methods

private func decodeModel<M: Decodable>(_ snapshot: DocumentSnapshot?) -> M? {
  if let data = snapshot?.data(), let model: M = tryDecode(data) {
    return model
  }
  return nil
}

private func decodeModels<M: Decodable>(_ documents: [QueryDocumentSnapshot]?) -> [M]? {
  documents?
    .map { $0.data() }
    .compactMap { tryDecode($0) }
}
