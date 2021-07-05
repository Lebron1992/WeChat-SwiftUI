import SwiftUI

extension Image {

  func resize(
    _ contentMode: ContentMode = .fill,
    _ size: CGSize? = nil
  ) -> some View {

    let content = resizable().aspectRatio(contentMode: contentMode)

    if let size = size {
      return AnyView(content.frame(width: size.width, height: size.height))
    }

    return AnyView(content)
  }
}
