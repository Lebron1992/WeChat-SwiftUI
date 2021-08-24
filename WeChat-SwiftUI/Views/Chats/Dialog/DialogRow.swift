import SwiftUI

struct DialogRow: View {

  let dialog: Dialog

  var body: some View {
    HStack {
      avatar
      VStack(alignment: .leading, spacing: 5) {
        HStack(alignment: .top) {
          title
          Spacer()
          lastMessageTime
        }
        lastMessageText
      }
    }
    .padding(Constant.contentInset)
  }

  private var avatar: some View {
    Image.avatarPlaceholder
      .resize(.fill, Constant.avatarSize)
      .cornerRadius(Constant.avatarCornerRadius)
  }

  private var title: some View {
    Text(dialog.name ?? "")
      .font(.system(size: Constant.titleFontSize, weight: .regular))
      .foregroundColor(.text_primary)
  }

  @ViewBuilder
  private var lastMessageTime: some View {
    if let time = dialog.lastMessageTimeString {
      Text(time)
        .font(.system(size: Constant.lastMessageTimeFontSize))
        .foregroundColor(.text_info_50)
    }
  }

  @ViewBuilder
  private var lastMessageText: some View {
    if let text = dialog.lastMessageText {
      Text(text)
        .lineLimit(1)
        .font(.system(size: Constant.lastMessageTextFontSize))
        .foregroundColor(.text_info_80)
    }
  }
}

// MARK: - Constant
private extension DialogRow {
  enum Constant {
    static let contentInset: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
    static let avatarSize: CGSize = .init(width: 48, height: 48)
    static let avatarCornerRadius: CGFloat = 8
    static let titleFontSize: CGFloat = 16
    static let lastMessageTimeFontSize: CGFloat = 11
    static let lastMessageTextFontSize: CGFloat = 15
  }
}

struct DialogRow_Previews: PreviewProvider {
  static var previews: some View {
    DialogRow(dialog: .template1)
  }
}
