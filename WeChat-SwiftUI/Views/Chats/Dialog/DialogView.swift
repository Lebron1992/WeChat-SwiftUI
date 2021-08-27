import SwiftUI
import SwiftUIRedux

struct DialogView: ConnectedView {

  let dialog: Dialog

  @State
  private var dismissKeyboard = false

  struct Props {
    let dialog: Dialog
    let appendMessageToDialog: (Message, Dialog) -> Void
  }

  func map(state: AppState, dispatch: @escaping Dispatch) -> Props {
    Props(
      dialog: state.chatsState.dialogs.element(matching: dialog),
      appendMessageToDialog: { dispatch(ChatsActions.AppendMessageToDialog(message: $0, dialog: $1)) }
    )
  }

  func body(props: Props) -> some View {
    VStack(spacing: 0) {
      messagesList(props: props)
      chatInputPanel(props: props)
    }
    .navigationTitle(props.dialog.name ?? "")
  }
}

// MARK: - Views
private extension DialogView {
  func messagesList(props: Props) -> some View {
    MessagesList(messages: props.dialog.messages)
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

  func chatInputPanel(props: Props) -> some View {
    ChatInputPanel(
      dismissKeyboard: dismissKeyboard,
      onSubmitText: { onSubmitText($0, props: props) }
    )
  }
}

// MARK: - Send Text
private extension DialogView {
  func onSubmitText(_ text: String, props: Props) {
    guard text.isEmpty == false else {
      return
    }
    let message = Message(text: text)
    withAnimation {
      props.appendMessageToDialog(message, props.dialog)
    }
  }
}

struct DialogView_Previews: PreviewProvider {
  static var previews: some View {
    DialogView(dialog: .template1)
      .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
