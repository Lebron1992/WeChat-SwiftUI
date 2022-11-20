import SwiftUI

struct ContactCategoryRow: View {

  var body: some View {
    HStack(spacing: Constant.imageTitleSpacing) {
      Image(category.icon)
        .resize(.fill, Constant.imageSize)
        .foregroundColor(.white)
        .frame(width: Constant.imageContainerSize.width, height: Constant.imageContainerSize.height)
        .background(category.iconBgColor)
        .cornerRadius(Constant.imageContainerCornerRadius)

      Text(category.title)
        .font(.system(size: Constant.titleFontSize))
        .foregroundColor(.text_primary)
    }
  }

  let category: ContactCategory
}

private extension ContactCategoryRow {
  enum Constant {
    static let imageTitleSpacing: CGFloat = 16
    static let imageSize: CGSize = .init(width: 25, height: 25)
    static let imageContainerSize: CGSize = .init(width: 40, height: 40)
    static let imageContainerCornerRadius: CGFloat = 4
    static let titleFontSize: CGFloat = 16
  }
}

struct ContactRowCategory_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        ContactCategoryRow(category: .groupChats)
        ContactCategoryRow(category: .tags)
        ContactCategoryRow(category: .officalAccounts)
        ContactCategoryRow(category: .weChatWorkContacts)
      }
      .background(.blue)
    }
}
