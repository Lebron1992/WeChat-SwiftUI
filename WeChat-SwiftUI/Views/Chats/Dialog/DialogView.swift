import SwiftUI
import SwiftUIRedux

struct DialogView: ConnectedView {

  @StateObject
  var viewModel: DialogViewModel

  @EnvironmentObject
  private var store: Store<AppState>

  @State
  private var dismissKeyboard = false

  struct Props {
    let dialog: Dialog
    let messages: [Message]
    let loadMessages: (Dialog) -> Void
    let sendMessage: (Message, Dialog) -> Void
  }

  func map(state: AppState, dispatch: @escaping Dispatch) -> Props {
    Props(
      dialog: state.chatsState.dialogs.element(matching: viewModel.dialog),
      messages: state.chatsState.dialogMessages.first(where: { $0.dialogId == viewModel.dialog.id })?.messages ?? [],
      loadMessages: { dispatch(ChatsActions.LoadMessagesForDialog(dialog: $0)) },
      sendMessage: { dispatch(ChatsActions.SendMessageInDialog(message: $0, dialog: $1)) }
    )
  }

  func body(props: Props) -> some View {
    VStack(spacing: 0) {
      messagesList(props: props)
      chatInputPanel(props: props)
    }
    .navigationTitle(props.dialog.name ?? "")
    .onAppear(perform: { props.loadMessages(viewModel.dialog) })
    .onChange(of: viewModel.messageChanges, perform: { handleMessageChanges($0, for: props.dialog) })
  }
}

// MARK: - Views
private extension DialogView {
  func messagesList(props: Props) -> some View {
    MessagesList(messages: props.messages)
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
      props.sendMessage(message, props.dialog)
    }
  }
}

// MARK: - Helper Methods
private extension DialogView {
  func handleMessageChanges(_ messageChanges: [MessageChange], for dialog: Dialog) {
    store.dispatch(action: ChatsActions.UpdateMessagesForDialog(
      messageChanges: messageChanges,
      dialog: dialog
    ))
  }
}

struct DialogView_Previews: PreviewProvider {
  static var previews: some View {
    DialogView(viewModel: .init(dialog: .template1))
      .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
