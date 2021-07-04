import SwiftUI
import URLImage

/* TODO:
 1. 导航栏背景改为白色
 */

struct ContactDetail: View {
  let contact: User

  var body: some View {
    List {
      Section {
        InfoRow()
        ForEach([TextRowItem.editContact, TextRowItem.privacy], id: \.self) { item in
          RowTitle(item.title)
        }
      }

      Section(header: SectionHeader()) {
        ForEach([TextRowItem.moment, TextRowItem.more], id: \.self) { item in
          RowTitle(item.title)
        }
      }

      Section(header: SectionHeader()) {
        VStack(spacing: 0) {
          Button {
            print("send messages")
          } label: {
            HStack {
              Image("icons_outlined_chats")
              Text(Strings.contact_detail_messages())
            }
            .frame(height: 52)
          }

          Color.bg_info_200
            .frame(height: 0.8)

          Button {
            print("voice or video call")
          } label: {
            HStack {
              Image("icons_outlined_videocall")
              Text(Strings.contact_detail_voice_or_video_call())
            }
            .frame(height: 52)
          }
        }
        .foregroundColor(.link)
        .font(.system(size: 16, weight: .medium))
        .buttonStyle(BorderlessButtonStyle()) // 解决：点击其中一个按钮导致两个按钮触发点击事件和 cell 被点击选中
        .listRowInsets(.zero)
      }
    }
    .listRowBackground(Color.app_white)
    .environment(\.defaultMinListHeaderHeight, 10)
  }
}

private extension ContactDetail {

  func InfoRow() -> some View {
    HStack(spacing: 20) {
      if let url = URL(string: contact.avatar) {
        URLImage(
          url,
          empty: { avatarPlaceholder },
          inProgress: { _ in avatarPlaceholder },
          failure: { _, _ in avatarPlaceholder },
          content: { image in
            image
              .resizeToFill()
              .frame(width: 60, height: 60)
          })
          .background(Color.app_bg)
          .cornerRadius(6)
      }

      VStack(alignment: .leading, spacing: 5) {
        HStack {
          Text(contact.name)
            .foregroundColor(.text_primary)
            .font(.system(size: 20, weight: .semibold))
          Image(contact.isMale ? "icons_filled_colorful_male" : "icons_filled_colorful_female")
            .resizeToFill()
            .frame(width: 18, height: 18)
        }

        Text("\(Strings.general_wechat_id()): \(contact.wechatId)")
          .foregroundColor(.text_info_200)
          .font(.system(size: 14))

        Text("\(Strings.general_region()): \(contact.region)")
          .foregroundColor(.text_info_200)
          .font(.system(size: 14))
      }
    }
    .padding(.bottom, 20)
  }

  func RowTitle(_ title: String) -> some View {
    NavigationLink(destination: Text(title)) {
      Text(title)
        .foregroundColor(.text_primary)
        .font(.system(size: 16))
        .frame(height: 44)
    }
  }

  func SectionHeader() -> some View {
    Color.app_bg
      .listRowInsets(.zero)
  }

  var avatarPlaceholder: some View {
    Image.avatarPlaceholder
      .resizeToFill()
      .foregroundColor(.app_bg)
      .frame(width: 60, height: 60)
  }
}

extension ContactDetail {
  enum TextRowItem {
    case editContact
    case privacy
    case moment
    case more

    var title: String {
      switch self {
      case .editContact: return Strings.contact_detail_edit_contact()
      case .privacy:     return Strings.contact_detail_privacy()
      case .moment:      return Strings.contact_detail_moments()
      case .more:        return Strings.contact_detail_more()
      }
    }
  }
}

struct ContactDetail_Previews: PreviewProvider {
  static var previews: some View {
    ContactDetail(contact: .template)
  }
}
