import SwiftUI
import URLImage

struct ImageTitleRow<Destination: View>: View {

  let image: Image?
  let imageUrl: URL?
  let imagePlaceholder: Image?
  let imageColor: Color?
  let imageSize: CGSize?
  let imageContentMode: ContentMode
  let imageCornerRadius: CGFloat

  let title: String
  let titleColor: Color
  let titleSize: CGFloat

  let rowHeight: CGFloat
  let showRightArrow: Bool
  let destination: (() -> Destination)?

  init(
    image: Image? = nil,
    imageUrl: URL? = nil,
    imagePlaceholder: Image? = nil,
    imageColor: Color? = nil,
    imageSize: CGSize? = nil,
    imageContentMode: ContentMode = .fill,
    imageCornerRadius: CGFloat = 0,
    title: String,
    titleColor: Color = .text_primary,
    titleSize: CGFloat = 16,
    rowHeight: CGFloat = 44,
    showRightArrow: Bool = true,
    destination: (() -> Destination)? = nil
  ) {
    self.image = image
    self.imageUrl = imageUrl
    self.imagePlaceholder = imagePlaceholder
    self.imageColor = imageColor
    self.imageSize = imageSize
    self.imageContentMode = imageContentMode
    self.imageCornerRadius = imageCornerRadius
    self.title = title
    self.titleColor = titleColor
    self.titleSize = titleSize
    self.rowHeight = rowHeight
    self.showRightArrow = showRightArrow
    self.destination = destination
  }

  var body: some View {
    let content =
    HStack {
      if let image = image {
        image
          .resize(imageContentMode, imageSize)
          .foregroundColor(imageColor)
          .cornerRadius(imageCornerRadius)
      }

      if let url = imageUrl {
        URLPlaceholderImage(url, size: imageSize, contentMode: imageContentMode) {
          imagePlaceholder
        }
        .foregroundColor(imageColor)
        .background(.app_bg)
        .cornerRadius(imageCornerRadius)
      }

      Text(title)
        .foregroundColor(titleColor)
        .font(.system(size: titleSize))
    }
    .frame(height: rowHeight)

    if let destination = destination?() {
      return ZStack(alignment: .leading) {
        NavigationLink(destination: destination) {
          EmptyView()
        }
        .opacity(showRightArrow ? 1 : 0)
        content
      }
      .asAnyView()
    }
    return content.asAnyView()
  }
}

struct ImageTitleRow_Previews: PreviewProvider {
  static var previews: some View {
    ImageTitleRow(
      image: Image("icons_outlined_colorful_favorites"),
      imageSize: .init(width: 20, height: 20),
      title: "Favorites",
      destination: { Text("Hello") }
    )
  }
}
