import Foundation
import FirebaseFirestore

struct MessageChange: Equatable {
  let message: Message
  let changeType: DocumentChangeType
}
