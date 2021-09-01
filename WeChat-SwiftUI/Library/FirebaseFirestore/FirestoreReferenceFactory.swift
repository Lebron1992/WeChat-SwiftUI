import FirebaseFirestore

enum FirestoreReferenceFactory {
  static func reference(for type: FirestoreReferenceType) -> CollectionReference {
    Firestore.firestore().collection(type.pathComponents.joined(separator: "/"))
  }
}

enum FirestoreReferenceType {
  case dialogs
  case officialAccounts
  case users

  var pathComponents: [String] {
    switch self {
    case .dialogs:
      return ["dialogs"]
    case .officialAccounts:
      return ["officialAccounts"]
    case .users:
      return ["users"]
    }
  }
}
