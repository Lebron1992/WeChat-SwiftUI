import SwiftUI
import SwiftUIRedux
import LBJImagePreviewer

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
    Group {
      if let uiImage = image.uiImage {
        LBJImagePreviewer(uiImage: uiImage)
      } else if let url = image.url {
        let urlImage = URLPlaceholderImage(url) {
          urlImagePlaceholder()
        }
        LBJViewZoomer(content: urlImage, aspectRatio: image.size.width / image.size.height)
      }
    }
    .onTapGesture { showPreview = false }
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
