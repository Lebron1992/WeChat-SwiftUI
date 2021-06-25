import SwiftUI

struct ContactCategoryRow: View {
  let category: ContactCategory

  var body: some View {
    HStack(spacing: 15) {
      Image(category.icon)
        .resizable()
        .frame(width: 25, height: 25)
        .foregroundColor(.white)
        .frame(width: 40, height: 40)
        .background(category.iconBgColor)
        .cornerRadius(4)

      Text(category.title)
        .font(.system(size: 16))
        .foregroundColor(.text_primary)
    }
  }
}

struct ContactRowCategory_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        ContactCategoryRow(category: .groupChats)
        ContactCategoryRow(category: .tags)
        ContactCategoryRow(category: .officalAccount)
        ContactCategoryRow(category: .weChatWorkContacts)
      }
      .background(Color.blue)
    }
}
