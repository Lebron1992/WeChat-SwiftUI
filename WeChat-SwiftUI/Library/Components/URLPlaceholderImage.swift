import SwiftUI
import URLImage

struct URLPlaceholderImage<Placeholder: View>: View {

  private let url: URL?
  private let size: CGSize?
  private let contentMode: ContentMode
  private let placeholder: () -> Placeholder

  init(
    _ url: URL?,
    size: CGSize? = nil,
    contentMode: ContentMode = .fill,
    @ViewBuilder placeholder: @escaping () -> Placeholder
  ) {
    self.url = url
    self.size = size
    self.contentMode = contentMode
    self.placeholder = placeholder
  }

  init(
    _ urlString: String?,
    size: CGSize? = nil,
    contentMode: ContentMode = .fill,
    @ViewBuilder placeholder: @escaping () -> Placeholder
  ) {
    self.init(
      .init(string: urlString ?? ""),
      size: size,
      contentMode: contentMode,
      placeholder: placeholder
    )
  }

  var body: some View {
    if let url = url {
      URLImage(
        url,
        empty: { styledPlaceholder },
        inProgress: { _ in styledPlaceholder },
        failure: { _, _  in styledPlaceholder },
        content: { image in
          image
            .resize(contentMode, size)
        })
    } else {
      styledPlaceholder
    }
  }

  @ViewBuilder
  private var styledPlaceholder: some View {
    if let image = placeholder() as? Image {
      image
        .resize(contentMode, size)
    } else {
      placeholder()
        .frame(width: size?.width, height: size?.height)
    }
  }
}
