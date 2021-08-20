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
    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
  }

  private var avatar: some View {
    Image.avatarPlaceholder
      .resize(.fill, .init(width: 48, height: 48))
      .cornerRadius(8)
  }

  private var title: some View {
    Text(dialog.name ?? "")
      .font(.system(size: 16, weight: .regular))
      .foregroundColor(.text_primary)
  }

  @ViewBuilder
  private var lastMessageTime: some View {
    if let time = dialog.lastMessageTimeString {
      Text(time)
        .font(.system(size: 11))
        .foregroundColor(.text_info_50)
    }
  }

  @ViewBuilder
  private var lastMessageText: some View {
    if let text = dialog.lastMessageText {
      Text(text)
        .lineLimit(1)
        .font(.system(size: 15))
        .foregroundColor(.text_info_80)
    }
  }
}

struct DialogRow_Previews: PreviewProvider {
  static var previews: some View {
    DialogRow(dialog: .template1)
  }
}
