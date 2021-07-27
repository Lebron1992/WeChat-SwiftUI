import SwiftUI

struct DialogRow: View {

  let dialog: Dialog

  var body: some View {
    HStack {
      Image.avatarPlaceholder
        .resize(.fill, .init(width: 48, height: 48))
        .cornerRadius(8)

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .top) {
          Text(dialog.name ?? "")
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.text_primary)

          Spacer()

          if let time = dialog.lastMessageTimeString {
            Text(time)
              .font(.system(size: 11))
              .foregroundColor(.text_info_50)
          }
        }

        if let text = dialog.lastMessageText {
          Text(text)
            .lineLimit(1)
            .font(.system(size: 15))
            .foregroundColor(.text_info_80)
        }
      }
    }
    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
  }
}

struct DialogRow_Previews: PreviewProvider {
  static var previews: some View {
    DialogRow(dialog: .template1)
  }
}
