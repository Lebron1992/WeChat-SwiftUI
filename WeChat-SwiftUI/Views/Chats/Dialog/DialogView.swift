import SwiftUI

struct DialogView: View {
  let dialog: Dialog

  @State
  private var dismissKeyboard = false

  var body: some View {
    VStack(spacing: 0) {
      messagesList
      ChatInputPanel(dismissKeyboard: dismissKeyboard)
    }
    .navigationTitle(dialog.name ?? "")
  }

  private var messagesList: some View {
    MessagesList(messages: dialog.messages)
      .resignKeyboardOnDrag {
        dismissKeyboard = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          dismissKeyboard = false
        }
      }
      .resignKeyboardOnTap {
        dismissKeyboard = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          dismissKeyboard = false
        }
      }
  }
}

struct DialogView_Previews: PreviewProvider {
  static var previews: some View {
    DialogView(dialog: .template1)
      .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
