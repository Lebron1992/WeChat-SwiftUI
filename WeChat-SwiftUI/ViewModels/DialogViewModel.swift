import Combine
import SwiftUI
import FirebaseFirestore
import SwiftUIRedux

final class DialogViewModel: ObservableObject {

  let dialog: Dialog

  @Published
  private(set) var messageChanges: [MessageChange] = []
  private var dialogMessagesListener: ListenerRegistration?

  init(dialog: Dialog) {
    self.dialog = dialog

    dialogMessagesListener = FirestoreReferenceFactory
      .reference(for: .dialogMessages(dialogId: dialog.id))
      .addSnapshotListener({ [weak self] snapshot, _ in
        self?.messageChanges = snapshot?
          .documentChanges
          .compactMap {
            if let message: Message = tryDecode($0.document.data()) {
              return MessageChange(message: message, changeType: $0.type)
            }
            return nil
          } ?? []
      })
  }

  deinit {
    dialogMessagesListener?.remove()
  }
}
