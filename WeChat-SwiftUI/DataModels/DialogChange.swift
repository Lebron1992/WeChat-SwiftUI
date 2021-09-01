import FirebaseFirestore

struct DialogChange: Equatable {
  let dialog: Dialog
  let changeType: DocumentChangeType
}
