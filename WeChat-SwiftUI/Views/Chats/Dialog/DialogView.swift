import SwiftUI

struct DialogView: View {

  @State
  private var dismissKeyboardOnTapOrDrag = false

  var body: some View {
    VStack(spacing: 0) {
      MessagesList(messages: [Message.textTemplate, Message.textTemplate2])
        .resignKeyboardOnDrag {
          dismissKeyboardOnTapOrDrag = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismissKeyboardOnTapOrDrag = false
          }
        }
        .resignKeyboardOnTap {
          dismissKeyboardOnTapOrDrag = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismissKeyboardOnTapOrDrag = false
          }
        }

      ChatInputPanel(dismissKeyboardOnTapOrDrag: dismissKeyboardOnTapOrDrag)
    }
  }
}

struct DialogView_Previews: PreviewProvider {
  static var previews: some View {
    DialogView()
      .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
