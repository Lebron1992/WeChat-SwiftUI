import SwiftUI
import SwiftUIRedux
import LBJMediaBrowser

struct MessageContentImage: View {
  let message: Message

  @EnvironmentObject
  private var store: Store<AppState>

  @EnvironmentObject
  private var dialogBox: ObjectBox<Dialog>

  @State
  private var errorMessage: String?

  @State
  private var showPreview = false

  var body: some View {
    HStack {
      errorIndicator
      ZStack {
        image(thatFits: contentSize)
        progressContainer(progress: image.progress, size: contentSize)
      }
      .cornerRadius(6)
      .onTapGesture { showPreview = true }
    }
    .alert(item: $errorMessage) {
      Alert(
        title: Text(Strings.chat_resend_message_title()),
        message: Text($0),
        primaryButton: .cancel(Text(Strings.general_cancel())),
        secondaryButton: resendButton
      )
    }
    .fullScreenCover(isPresented: $showPreview) { imagePreview }
  }
}

private extension MessageContentImage {
  @ViewBuilder
  var errorIndicator: some View {
    if let status = message.image?.localImage?.status,
       case let .failed(error) = status {
      Button {
        errorMessage = error.localizedDescription
      } label: {
        Image("icons_filled_error")
          .foregroundColor(.red)
      }
      .buttonStyle(.plain)
    }
  }

  var resendButton: Alert.Button {
    Alert.Button.default(
      Text(Strings.chat_resend()).foregroundColor(.link)
    ) {
      store.dispatch(action: ChatsActions.SendImageMessageInDialog(message: message, dialog: dialogBox.value))
    }
  }

  @ViewBuilder
  func image(thatFits size: CGSize) -> some View {
    if let image = image.uiImage {
      Image(uiImage: image)
        .resize(.fill, size)
    } else if let url = image.url {
      URLPlaceholderImage(url, size: size) {
        urlImagePlaceholder(with: size)
      }
    }
  }

  @ViewBuilder
  var imagePreview: some View {
    let imageMessages = store.state.chatsState.dialogMessages
      .first(where: { $0.dialogId == dialogBox.value.id })?
      .messages
      .filter { $0.isImageMsg }
      ?? []

    let medias: [Media] = imageMessages.compactMap { message in
        if let uiImage = message.image?.localImage?.uiImage {
          return MediaUIImage(uiImage: uiImage)
        }
        if let url = URL(string: message.image?.urlImage?.url ?? "") {
          return MediaURLImage(imageUrl: url)
        }
        return nil
      }
    let currentPage = imageMessages.firstIndex(of: message) ?? 0
    let browser = LBJPagingBrowser(medias: medias, currentPage: currentPage)

    LBJPagingMediaBrowser(browser: browser)
      .onTapMedia { _ in
        showPreview = false
      }
  }

  @ViewBuilder
  func urlImagePlaceholder(with size: CGSize? = nil) -> some View {
    if let image = image.uiImage {
      Image(uiImage: image)
        .resize(.fill, size)
    } else {
      Color.black.opacity(Constant.placeholderOpacity)
    }
  }

  @ViewBuilder
  func progressContainer(progress: Float, size: CGSize) -> some View {
    if image.isUploadFailed == false && progress < 1 {
      ZStack {
        Color.black.opacity(Constant.progressCoverOpacity)
        MediaLoadingProgressView(progress: progress)
          .frame(
            width: Constant.progressSize.width,
            height: Constant.progressSize.height
          )
      }
      .frame(width: size.width, height: size.height)
    }
  }

  var image: Message.Image {
    message.image!
  }

  var contentSize: CGSize {
    message.image!.size.aspectSize(fitsSize: Constant.maxImageSize)
  }
}

private extension MessageContentImage {
  enum Constant {
    static let placeholderOpacity = 0.3
    static let progressCoverOpacity = 0.3
    static let progressSize: CGSize = .init(width: 40, height: 40)
    static let maxImageSize: CGSize = .init(width: 155, height: 155)
  }
}

struct MessageRowImage_Previews: PreviewProvider {
  static var previews: some View {
    VStack(alignment: .trailing, spacing: 10) {
      let images = [
        Message.urlImageTemplate,
        Message.uiImageTemplateIdle,
        Message.uiImageTemplateUploaded,
        Message.uiImageTemplateError
      ]
      ForEach(images) { message in
        MessageContentImage(message: message)
      }
    }
  }
}
