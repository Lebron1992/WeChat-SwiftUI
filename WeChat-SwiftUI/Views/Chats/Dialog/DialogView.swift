import SwiftUI
import SwiftUIRedux

struct DialogView: ConnectedView {

  @StateObject
  var viewModel: DialogViewModel

  @EnvironmentObject
  private var store: Store<AppState>

  @State
  private var dismissKeyboard = false

  @State
  private var photoPicker: PhotoPickerType?

  @State
  private var pickedPhoto: UIImage?

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
      sendMessage: { message, dialog in
        if message.isTextMsg {
          dispatch(ChatsActions.SendTextMessageInDialog(message: message, dialog: dialog))
        } else if message.isImageMsg {
          dispatch(ChatsActions.SendImageMessageInDialog(message: message, dialog: dialog))
        }
      }
    )
  }

  func body(props: Props) -> some View {
    ScrollViewReader { scrollView in
      VStack(spacing: 0) {
        messagesList(props: props)
        chatInputPanel(props: props, scrollView: scrollView)
      }
      .onChange(of: props.messages) { scrollToLastMessage($0.last, with: scrollView) }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
          // 不延迟的话，scroll 无效
          scrollToLastMessage(props.messages.last, with: scrollView, animated: false)
        }
      }
    }
    .navigationTitle(props.dialog.name ?? "")
    .sheet(item: $photoPicker) { pickerType in
      switch pickerType {
      case .camera: ImagePicker(sourceType: .camera, allowsEditing: false) { handlePickedImage($0) }
      case .library: ImagePicker(sourceType: .photoLibrary, allowsEditing: false) { handlePickedImage($0) }
      }
    }
    .onAppear { props.loadMessages(viewModel.dialog) }
    .onChange(of: viewModel.messageChanges) { handleMessageChanges($0, for: props.dialog) }
    .onChange(of: pickedPhoto) { onPickedImage($0, props: props) }
    .environmentObject(ObjectBox(value: props.dialog))
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

  func chatInputPanel(props: Props, scrollView: ScrollViewProxy) -> some View {
    ChatInputPanel(
      dismissKeyboard: dismissKeyboard,
      onInputStarted: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          scrollToLastMessage(props.messages.last, with: scrollView)
        }
      },
      onSubmitText: { onSubmitText($0, props: props) },
      onAddButtonTapped: { photoPicker = .library }
    )
  }
}

// MARK: - Send
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

  func onPickedImage(_ image: UIImage?, props: Props) {
    guard let image = image else {
      return
    }
    let message = Message(image: .init(uiImage: image))
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

  func handlePickedImage(_ image: UIImage?) {
    pickedPhoto = image
    photoPicker = nil
  }

  func scrollToLastMessage(
    _ message: Message?,
    with scrollView: ScrollViewProxy,
    animated: Bool = true
  ) {
    guard let message = message else {
      return
    }
    if animated {
      withAnimation {
        scrollView.scrollTo(message, anchor: .bottom)
      }
    } else {
      scrollView.scrollTo(message, anchor: .bottom)
    }
  }
}

struct DialogView_Previews: PreviewProvider {
  static var previews: some View {
    DialogView(viewModel: .init(dialog: .template1))
      .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
