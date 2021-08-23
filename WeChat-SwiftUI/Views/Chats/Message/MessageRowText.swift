import SwiftUI
import URLImage

struct MessageRowText: View {
  let message: Message

  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      if message.isOutgoingMsg {
        Spacer(minLength: Constant.spacingOfContentMaxWidthToEdge)
      } else {
        avatar
      }

      messageText

      if message.isOutgoingMsg {
        avatar
      } else {
        Spacer(minLength: Constant.spacingOfContentMaxWidthToEdge)
      }
    }
    .listRowBackground(Color.app_bg)
  }
}

private extension MessageRowText {

  var avatar: some View {
    URLPlaceholderImage(message.sender.avatar, size: Constant.avatarSize) {
      Image.avatarPlaceholder
    }
    .background(.app_white)
    .cornerRadius(Constant.avatarCornerRadius)
  }

  var messageText: some View {
    HStack(alignment: .top, spacing: -Constant.textBackgroundArrowOverlapWidth) {
      if message.isOutgoingMsg == false {
        textBackgroundArrow
      }

      Text(message.text!)
        .font(Font(Constant.textFont as CTFont))
        .foregroundColor(textForegroundColor)
        .padding(Constant.textInsets)
        .background(textBackgroundColor)
        .cornerRadius(Constant.textBackgroundCornerRadius)

      if message.isOutgoingMsg {
        textBackgroundArrow
      }
    }
  }

  var textBackgroundArrow: some View {
    VStack(alignment: .center) {
      Path { path in
        path.addRoundedRect(
          in: .init(
            x: 0,
            y: 0,
            width: Constant.textBackgroundArrowWidth,
            height: Constant.textBackgroundArrowWidth
          ),
          cornerSize: .init(width: 1, height: 1)
        )
      }
      .frame(width: Constant.textBackgroundArrowWidth, height: Constant.textBackgroundArrowWidth)
      .foregroundColor(textBackgroundColor)
      .rotationEffect(.init(degrees: 45))
    }
    .frame(width: Constant.textBackgroundArrowContainerWidth, height: Constant.textBackgroundArrowContainerHeight)
  }

  var textForegroundColor: Color {
    message.isOutgoingMsg ? Color.text_chat_outgoing_msg : Color.text_chat_incoming_msg
  }

  var textBackgroundColor: Color {
    message.isOutgoingMsg ? Color.bg_chat_outgoing_msg : Color.bg_chat_incoming_msg
  }
}

extension MessageRowText {
  enum Constant {
    static let spacingOfContentMaxWidthToEdge: CGFloat = 50

    static let avatarSize: CGSize = .init(width: 40, height: 40)
    static let avatarCornerRadius: CGFloat = 4

    static let textFont: UIFont = .systemFont(ofSize: 17)
    static let textInsets: EdgeInsets = .init(top: 10, leading: 12, bottom: 10, trailing: 12)
    static let textBackgroundCornerRadius: CGFloat = 4

    static let textBackgroundArrowWidth: CGFloat = 10
    static let textBackgroundArrowOverlapWidth: CGFloat = sqrt((pow(textBackgroundArrowWidth, 2)) * 2) / 2

    static let textBackgroundArrowContainerWidth = textBackgroundArrowOverlapWidth * 2
    static let textBackgroundArrowContainerHeight = textFont.lineHeight + textInsets.top + textInsets.bottom
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
