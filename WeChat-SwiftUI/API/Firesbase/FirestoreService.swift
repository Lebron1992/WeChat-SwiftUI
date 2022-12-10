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

  func insert(_ message: Message, to dialog: Dialog) async throws -> Success {
    try await withCheckedThrowingContinuation({ continuation in
      dialogsCollection
        .document(dialog.id)
        .collection("messages")
        .document(message.id)
        .setData(message.dictionaryRepresentation ?? [:]) { error in
          if let e = error {
            continuation.resume(throwing: e.toEnvelope())
          } else {
            continuation.resume(returning: .init())
          }
        }
    })
  }

  func loadContacts() async throws -> [User] {
    try await withCheckedThrowingContinuation({ continuation in
      usersCollection
        .getDocuments { snapshot, error in
          if let err = error {
            continuation.resume(throwing: err)
          } else if let users: [User] = decodeModels(snapshot?.documents) {
            continuation.resume(returning: users)
          } else {
            let error = NSError.commonError(description: "Can not decode [User] from snapshot")
            continuation.resume(throwing: error)
          }
        }
    })
  }

  func loadDialogs() async throws -> [Dialog] {
    try await withCheckedThrowingContinuation({ continuation in
      dialogsCollection
        .getDocuments { snapshot, error in
          if let err = error {
            continuation.resume(throwing: err)
          } else if let dialogs: [Dialog] = decodeModels(snapshot?.documents) {
            let filtered = dialogs.filter { $0.isSelfParticipated }
            continuation.resume(returning: filtered)
          } else {
            let error = NSError.commonError(description: "Can not decode [Dialog] from snapshot")
            continuation.resume(throwing: error)
          }
        }
    })
  }

  func loadMessages(for dialog: Dialog) async throws -> [Message] {
    try await withCheckedThrowingContinuation({ continuation in
      dialogsCollection
        .document(dialog.id)
        .collection("messages")
        .getDocuments { snapshot, error in
          if let err = error {
            continuation.resume(throwing: err)
          } else if let messages: [Message] = decodeModels(snapshot?.documents) {
            continuation.resume(returning: messages)
          } else {
            let error = NSError.commonError(description: "Can not decode [Message] from snapshot")
            continuation.resume(throwing: error)
          }
        }
    })
  }

  func loadOfficialAccounts() async throws -> [OfficialAccount] {
    try await withCheckedThrowingContinuation({ continuation in
      officialAccountsCollection
        .getDocuments { snapshot, error in
          if let err = error {
            continuation.resume(throwing: err)
          } else if let accounts: [OfficialAccount] = decodeModels(snapshot?.documents) {
            continuation.resume(returning: accounts)
          } else {
            let error = NSError.commonError(description: "Can not decode [OfficialAccount] from snapshot")
            continuation.resume(throwing: error)
          }
        }
    })
  }

  func loadUserSelf() async throws -> User {

    guard let userId = AppEnvironment.current.currentUser?.id else {
      let error = NSError.commonError(description: "currentUser is nil")
      throw error
    }

    return try await withCheckedThrowingContinuation({ continuation in
      usersCollection
        .document(userId)
        .getDocument { snapshot, error in
          if let err = error {
            continuation.resume(throwing: err)
          } else if let user: User = decodeModel(snapshot) {
            continuation.resume(returning: user)
          } else {
            let error = NSError.commonError(description: "Can not decode user from snapshot")
            continuation.resume(throwing: error)
          }
        }
    })
  }

  func overrideDialog(_ dialog: Dialog) async throws -> Success {
    try await withCheckedThrowingContinuation({ continuation in
      dialogsCollection
        .document(dialog.id)
        .setData(dialog.dictionaryRepresentation ?? [:]) { error in
          if let err = error {
            continuation.resume(throwing: err)
          } else {
            continuation.resume(returning: .init())
          }
        }
    })
  }

  func overrideUser(_ user: User) async throws {
    // `_: ()` fixes the issue where Generic parameter 'T' could not be inferred
    let _: () = try await withCheckedThrowingContinuation({ continuation in
      usersCollection
        .document(user.id)
        .setData(user.dictionaryRepresentation ?? [:]) { error in
          if let err = error {
            continuation.resume(throwing: err)
          } else {
            continuation.resume()
          }
        }
    })
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
