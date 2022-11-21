import SwiftUI
import ComposableArchitecture

struct DialogView: View {

  var body: some View {
    WithViewStore(store.wrappedValue, observe: { $0.chatsState }) { viewStore in
      let messages = viewStore.dialogMessages
        .first(where: { $0.dialogId == viewModel.dialog.id })?
        .messages ?? []
      let dialog = viewStore.dialogs.element(matching: viewModel.dialog)

      ScrollViewReader { scrollView in
        VStack(spacing: 0) {
          messagesList(messages: messages)
          chatInputPanel(
            lastMessage: messages.last,
            scrollView: scrollView,
            sendText: { viewStore.send(.chats(.sendTextMessageInDialog($0, dialog))) }
          )
        }
        .onChange(of: messages) { scrollToLastMessage($0.last, with: scrollView) }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            // 不延迟的话，scroll 无效
            scrollToLastMessage(messages.last, with: scrollView, animated: false)
          }
        }
      }
      .navigationTitle(dialog.name ?? "")
      .sheet(item: $photoPicker) { pickerType in
        switch pickerType {
        case .camera: ImagePicker(sourceType: .camera, allowsEditing: false) { handlePickedImage($0) }
        case .library: ImagePicker(sourceType: .photoLibrary, allowsEditing: false) { handlePickedImage($0) }
        }
      }
      .onAppear { viewStore.send(.chats(.loadMessagesForDialog(dialog))) }
      .onChange(of: viewModel.messageChanges) { viewStore.send(.chats(.updateMessagesForDialog($0, dialog))) }
      .onChange(of: pickedPhoto) { onPickedImage($0, send: {
        viewStore.send(.chats(.sendImageMessageInDialog($0, dialog)))
      }) }
      .environmentObject(ObjectBox(value: dialog))
    }
  }

  @StateObject
  var viewModel: DialogViewModel

  @EnvironmentObject
  private var store: StoreObservableObject<AppState, AppAction>

  @State
  private var dismissKeyboard = false

  @State
  private var photoPicker: PhotoPickerType?

  @State
  private var pickedPhoto: UIImage?
}

// MARK: - Views
private extension DialogView {
  func messagesList(messages: [Message]) -> some View {
    MessagesList(messages: messages)
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

  func chatInputPanel(
    lastMessage: Message?,
    scrollView: ScrollViewProxy,
    sendText: @escaping (Message) -> Void
  ) -> some View {
    ChatInputPanel(
      dismissKeyboard: dismissKeyboard,
      onInputStarted: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          scrollToLastMessage(lastMessage, with: scrollView)
        }
      },
      onSubmitText: { onSubmitText($0, send: sendText) },
      onAddButtonTapped: { photoPicker = .library }
    )
  }
}

// MARK: - Send
private extension DialogView {
  func onSubmitText(_ text: String, send: (Message) -> Void) {
    guard text.isEmpty == false else {
      return
    }
    let message = Message(text: text)
    withAnimation {
      send(message)
    }
  }

  func onPickedImage(_ image: UIImage?, send: (Message) -> Void) {
    guard let image = image else {
      return
    }
    let message = Message(image: .init(uiImage: image))
    withAnimation {
      send(message)
    }
  }
}

// MARK: - Helper Methods
private extension DialogView {
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
    let store = Store(
      initialState: AppState(chatsState: .init(
        dialogs: [.template1],
        dialogMessages: [.init(
          dialogId: Dialog.template1.id,
          messages: [.textTemplate1, .urlImageTemplate, .textTemplate2])]
      )),
      reducer: appReducer
    )
    DialogView(
      viewModel: .init(dialog: .template1)
    )
      .onAppear { AppEnvironment.updateCurrentUser(.template1) }
      .environmentObject(StoreObservableObject(store: store))
  }
}
