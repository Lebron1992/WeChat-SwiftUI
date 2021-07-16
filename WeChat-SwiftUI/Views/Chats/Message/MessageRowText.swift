import SwiftUI
import URLImage

struct MessageRowText: View {
  let message: Message

  var body: some View {
    let spacerLength: CGFloat = 50
    HStack(alignment: .top, spacing: 8) {
      if message.isOutgoingMsg {
        Spacer(minLength: spacerLength)
      } else {
        Avatar()
      }

      MessageText()

      if message.isOutgoingMsg {
        Avatar()
      } else {
        Spacer(minLength: spacerLength)
      }
    }
    .listRowBackground(Color.app_bg)
  }
}

private extension MessageRowText {
  func Avatar() -> some View {

    let size = CGSize(width: 40, height: 40)
    let avatarPlaceholder =
      Image.avatarPlaceholder
      .resize(.fill, size)
      .foregroundColor(.app_bg)

    if let url = URL(string: message.sender.avatar) {
      return AnyView(
        URLImage(
          url,
          empty: { avatarPlaceholder },
          inProgress: { _ in avatarPlaceholder },
          failure: { _, _ in avatarPlaceholder },
          content: { image in
            image
              .resize(.fill, size)
              .background(.white)
          })
          .background(.app_bg)
          .cornerRadius(4)
      )
    }

    return AnyView(avatarPlaceholder)
  }

  func MessageText() -> some View {
    HStack(alignment: .top, spacing: -textBackgroundArrowOverlapWidth) {
      if message.isOutgoingMsg == false {
        TextBackgroundArrow()
      }

      Text(message.text!)
        .font(.system(size: 17))
        .foregroundColor(textForegroundColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(textBackgroundColor)
        .cornerRadius(4)

      if message.isOutgoingMsg {
        TextBackgroundArrow()
      }
    }
  }

  func TextBackgroundArrow() -> some View {
    VStack(alignment: .center) {
      Path { path in
        path.addRoundedRect(
          in: .init(x: 0, y: 0, width: textBackgroundArrowWidth, height: textBackgroundArrowWidth),
          cornerSize: .init(width: 1, height: 1)
        )
      }
      .frame(width: textBackgroundArrowWidth, height: textBackgroundArrowWidth)
      .foregroundColor(textBackgroundColor)
      .rotationEffect(.init(degrees: 45))
    }
    .frame(width: textBackgroundArrowOverlapWidth * 2, height: 40)
  }

  var textForegroundColor: Color {
    message.isOutgoingMsg ? Color.text_chat_outgoing_msg : Color.text_chat_incoming_msg
  }

  var textBackgroundColor: Color {
    message.isOutgoingMsg ? Color.bg_chat_outgoing_msg : Color.bg_chat_incoming_msg
  }

  var textBackgroundArrowOverlapWidth: CGFloat {
    sqrt((textBackgroundArrowWidth * textBackgroundArrowWidth) * 2) / 2
  }

  var textBackgroundArrowWidth: CGFloat {
    10
  }
}

struct MessageRowText_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MessageRowText(message: .textTemplate)
      MessageRowText(message: .textTemplate2)
    }
    .padding(50)
    .background(.green)
    .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
