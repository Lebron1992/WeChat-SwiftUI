import Combine
import SwiftUI
import FirebaseFirestore
import SwiftUIRedux

final class DialogsListViewModel: ObservableObject {
  private var dialogsListener: ListenerRegistration?

  @Published
  private(set) var dialogChanges: [DialogChange] = []

  init() {
    dialogsListener = FirestoreReferenceFactory
      .reference(for: .dialogs)
      .addSnapshotListener({ [weak self] snapshot, _ in
        self?.dialogChanges = snapshot?
          .documentChanges
          .compactMap {
            if let dialog: Dialog = tryDecode($0.document.data()), dialog.isSelfParticipated {
              return DialogChange(dialog: dialog, changeType: $0.type)
            }
            return nil
          } ?? []
      })
  }

  deinit {
    dialogsListener?.remove()
  }
}
