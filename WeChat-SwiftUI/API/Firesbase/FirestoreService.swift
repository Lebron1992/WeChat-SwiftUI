import Combine
import ComposableArchitecture
import FirebaseFirestore

struct FirestoreService: FirestoreServiceType {

  private let dialogsCollection: CollectionReference
  private let officialAccountsCollection: CollectionReference
  private let usersCollection: CollectionReference

  init() {
    dialogsCollection = FirestoreReferenceFactory.reference(for: .dialogs)
    officialAccountsCollection = FirestoreReferenceFactory.reference(for: .officialAccounts)
    usersCollection = FirestoreReferenceFactory.reference(for: .users)
  }

  func insert(_ message: Message, to dialog: Dialog) -> Effect<Success, ErrorEnvelope> {
    Effect.future { promise in
      dialogsCollection
        .document(dialog.id)
        .collection("messages")
        .document(message.id)
        .setData(message.dictionaryRepresentation ?? [:]) { error in
          if let e = error {
            promise(Result.failure(e.toEnvelope()))
          } else {
            promise(Result.success(.init()))
          }
        }
    }
  }

  func loadContacts() -> Effect<[User], ErrorEnvelope> {
    Effect.future { promise in
      usersCollection
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err.toEnvelope()))

          } else if let users: [User] = decodeModels(snapshot?.documents) {
            promise(Result.success(users))

          } else {
            let error = NSError.commonError(description: "Can not decode [User] from snapshot")
            promise(Result.failure(error.toEnvelope()))
          }
        }
    }
  }

  func loadDialogs() -> Effect<[Dialog], ErrorEnvelope> {
    Effect.future { promise in
      dialogsCollection
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err.toEnvelope()))

          } else if let dialogs: [Dialog] = decodeModels(snapshot?.documents) {
            let filtered = dialogs.filter { $0.isSelfParticipated }
            promise(Result.success(filtered))

          } else {
            let error = NSError.commonError(description: "Can not decode [Dialog] from snapshot")
            promise(Result.failure(error.toEnvelope()))
          }
        }
    }
  }

  func loadMessages(for dialog: Dialog) -> Effect<[Message], ErrorEnvelope> {
    Effect.future { promise in
      dialogsCollection
        .document(dialog.id)
        .collection("messages")
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err.toEnvelope()))

          } else if let messages: [Message] = decodeModels(snapshot?.documents) {
            promise(Result.success(messages))

          } else {
            let error = NSError.commonError(description: "Can not decode [Message] from snapshot")
            promise(Result.failure(error.toEnvelope()))
          }
        }
    }
  }

  func loadOfficialAccounts() -> Effect<[OfficialAccount], ErrorEnvelope> {
    Effect.future { promise in
      officialAccountsCollection
        .getDocuments { snapshot, error in
          if let err = error {
            promise(Result.failure(err.toEnvelope()))

          } else if let accounts: [OfficialAccount] = decodeModels(snapshot?.documents) {
            promise(Result.success(accounts))

          } else {
            let error = NSError.commonError(description: "Can not decode [OfficialAccount] from snapshot")
            promise(Result.failure(error.toEnvelope()))
          }
        }
    }
  }

  func loadUserSelf() -> Effect<User, ErrorEnvelope> {

    guard let userId = AppEnvironment.current.currentUser?.id else {
      let error = NSError.commonError(description: "currentUser is nil")
      return .init(error: error.toEnvelope())
    }

    return Effect.future { promise in
      usersCollection
        .document(userId)
        .getDocument { snapshot, error in

          if let err = error {
            promise(Result.failure(err.toEnvelope()))

          } else if let user: User = decodeModel(snapshot) {
            promise(Result.success(user))

          } else {
            let error = NSError.commonError(description: "Can not decode user from snapshot")
            promise(Result.failure(error.toEnvelope()))
          }
        }
    }
  }

  func overrideDialog(_ dialog: Dialog) -> Effect<Success, ErrorEnvelope> {
    Effect.future { promise in
      dialogsCollection
        .document(dialog.id)
        .setData(dialog.dictionaryRepresentation ?? [:]) { error in
          if let e = error {
            promise(Result.failure(e.toEnvelope()))
          } else {
            promise(Result.success(.init()))
          }
        }
    }
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
