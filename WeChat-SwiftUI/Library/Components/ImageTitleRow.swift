import SwiftUI
import URLImage

/// 用于解决 `ImageTitleRow` 中在不使用泛型的情况下，无法把 `image` 和 `imagePlaceholder` 定义为 `View?` 的问题
struct ImageWrapper {
  let image: Image
  let contentMode: ContentMode
  let size: CGSize
  let foregroundColor: Color?

  init(
    image: Image,
    contentMode: ContentMode = .fill,
    size: CGSize,
    foregroundColor: Color? = nil
  ) {
    self.image = image
    self.contentMode = contentMode
    self.size = size
    self.foregroundColor = foregroundColor
  }

  var content: some View {
    if let color = foregroundColor {
      return AnyView(
        image
          .resize(contentMode, size)
          .foregroundColor(color)
      )
    }
    return AnyView(image)
  }
}

struct ImageTitleRow<Destination: View>: View {

  let image: ImageWrapper?
  let imageUrl: URL?
  let imagePlaceholder: ImageWrapper?
  let imageSize: CGSize?
  let imageCornerRadius: CGFloat

  let title: String
  let titleColor: Color
  let titleSize: CGFloat

  let destination: (() -> Destination)?
  let showRightArrow: Bool
  let rowHeight: CGFloat

  init(
    image: ImageWrapper? = nil,
    imageUrl: URL? = nil,
    imagePlaceholder: ImageWrapper? = nil,
    imageSize: CGSize? = nil,
    imageCornerRadius: CGFloat = 0,
    title: String,
    titleColor: Color = .text_primary,
    titleSize: CGFloat = 16,
    destination: (() -> Destination)? = nil,
    showRightArrow: Bool = true,
    rowHeight: CGFloat = 44
  ) {
    self.image = image
    self.imageUrl = imageUrl
    self.imagePlaceholder = imagePlaceholder
    self.imageSize = imageSize
    self.imageCornerRadius = imageCornerRadius
    self.title = title
    self.titleColor = titleColor
    self.titleSize = titleSize
    self.destination = destination
    self.showRightArrow = showRightArrow
    self.rowHeight = rowHeight
  }

  var body: some View {
    let content =
      HStack {
        if let image = image {
          image.content
        }

        if let url = imageUrl {
          let placeholder = imagePlaceholder?.content
          URLImage(
            url,
            empty: { placeholder },
            inProgress: { _ in placeholder },
            failure: { _, _ in placeholder },
            content: { image in
              image
                .resize(.fill, imageSize)
            })
            .background(Color.app_bg)
            .cornerRadius(imageCornerRadius)
        }

        Text(title)
          .foregroundColor(titleColor)
          .font(.system(size: titleSize))
      }
      .frame(height: rowHeight)

    if let destination = destination?() {
      return AnyView(
        ZStack(alignment: .leading) {
          NavigationLink(destination: destination) {
            EmptyView()
          }
          .opacity(showRightArrow ? 1 : 0)
          content
        })
    }
    return AnyView(content)
  }
}

struct ImageTitleRow_Previews: PreviewProvider {
  static var previews: some View {
    ImageTitleRow(
      image: ImageWrapper(image: Image("icons_outlined_colorful_favorites"), size: .init(width: 20, height: 20)),
      title: "Favorites",
      destination: { Text("Hello") }
    )
  }
}
