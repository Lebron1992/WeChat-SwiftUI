import SwiftUI

struct MessageContentImage: View {
  let message: Message

  var body: some View {
    ZStack {
      image(thatFits: contentSize)
      progressContainer(progress: image.progress, size: contentSize)
    }
    .cornerRadius(6)
  }
}

private extension MessageContentImage {
  @ViewBuilder
  func image(thatFits size: CGSize) -> some View {
    if let url = image.url {
      URLPlaceholderImage(url, size: size) {
        Color.black.opacity(Constant.placeholderOpacity)
      }
    } else if let image = image.uiImage {
      Image(uiImage: image)
        .resize(.fill, size)
    }
  }

  @ViewBuilder
  func progressContainer(progress: Float, size: CGSize) -> some View {
    if progress < 1 {
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
        Message.uiImageTemplateUploaded
      ]
      ForEach(images) { message in
        let maxImageSize = CGSize(width: 155, height: 155)
        let size = message.image!.size.aspectSize(fitsSize: maxImageSize)
        MessageContentImage(message: message)
          .frame(width: size.width, height: size.height)
      }
    }
  }
}
