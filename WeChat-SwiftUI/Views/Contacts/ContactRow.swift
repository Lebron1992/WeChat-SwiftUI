import SwiftUI
import URLImage

struct ContactRow<Contact: ContactType>: View {
  let contact: Contact

  var body: some View {
    HStack(spacing: 15) {
      if let url = URL(string: contact.avatar) {
        URLImage(
          url,
          empty: { avatarPlaceholder },
          inProgress: { _ in avatarPlaceholder },
          failure: { _, _ in avatarPlaceholder },
          content: { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 40, height: 40)
          })
          .background(Color.bg_info_200)
          .cornerRadius(4)
      }

      Text(contact.name)
        .font(.system(size: 16))
        .foregroundColor(.text_primary)
    }
  }

  private var avatarPlaceholder: some View {
    Image("icons_outlined_avatar")
      .resizable()
      .aspectRatio(contentMode: .fill)
      .foregroundColor(.bg_info_200)
      .frame(width: 40, height: 40)
  }
}

struct ContactRow_Previews: PreviewProvider {
  static var previews: some View {
    ContactRow(contact: User.template)
      .background(Color.blue)
  }
}
