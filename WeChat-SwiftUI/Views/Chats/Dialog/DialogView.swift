import SwiftUI

struct DialogView: View {

  @State
  private var dismissKeyboard = false

  var body: some View {
    VStack(spacing: 0) {
      messagesList
      ChatInputPanel(dismissKeyboard: dismissKeyboard)
    }
  }

  private var messagesList: some View {
    MessagesList(messages: [Message.textTemplate, Message.textTemplate2])
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
    DialogView()
      .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
