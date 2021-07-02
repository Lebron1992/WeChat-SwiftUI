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
        NavigationLink(destination: Text("Hello")) {
          RowTitle(Strings.contact_detail_edit_contact())
        }
        .frame(height: 44)
        NavigationLink(destination: Text("Hello")) {
          RowTitle(Strings.contact_detail_privacy())
        }
        .frame(height: 44)
      }
      .listRowBackground(Color.app_white)
      .font(.system(size: 16))

      SectionDivider()

      Section {
        NavigationLink(destination: Text("Hello")) {
          RowTitle(Strings.contact_detail_moments())
        }
        .frame(height: 44)
        NavigationLink(destination: Text("Hello")) {
          RowTitle(Strings.contact_detail_more())
        }
        .frame(height: 44)
      }
      .listRowBackground(Color.app_white)
      .font(.system(size: 16))

      SectionDivider()

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
      .listRowBackground(Color.app_white)
      .listRowInsets(.zero)
    }
    .environment(\.defaultMinListRowHeight, 10)
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
    Text(title)
      .foregroundColor(.text_primary)
  }

  func SectionDivider() -> some View {
    Color.app_bg
      .frame(height: 10)
      .listRowBackground(Color.app_bg)
      .listRowInsets(.zero)
  }

  var avatarPlaceholder: some View {
    Image.avatarPlaceholder
      .resizeToFill()
      .foregroundColor(.app_bg)
      .frame(width: 60, height: 60)
  }
}

struct ContactDetail_Previews: PreviewProvider {
  static var previews: some View {
    ContactDetail(contact: .template)
  }
}
