import SwiftUI
import URLImage

struct URLPlaceholderImage<Placeholder: View>: View {

  private let url: URL?
  private let size: CGSize
  private let placeholder: () -> Placeholder

  init(_ url: URL?, size: CGSize, @ViewBuilder placeholder: @escaping () -> Placeholder) {
    self.url = url
    self.size = size
    self.placeholder = placeholder
  }

  init(_ urlString: String, size: CGSize, @ViewBuilder placeholder: @escaping () -> Placeholder) {
    self.init(.init(string: urlString), size: size, placeholder: placeholder)
  }

  var body: some View {
    if let url = url {
      URLImage(
        url,
        empty: placeholder,
        inProgress: { _ in placeholder() },
        failure: { _, _  in placeholder() },
        content: { image in
          image
            .resize(.fill, size)
        })
    } else {
      placeholder()
    }
  }
}
