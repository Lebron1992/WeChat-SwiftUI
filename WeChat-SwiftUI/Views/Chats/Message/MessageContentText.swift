import SwiftUI
import URLImage

struct MessageContentText: View {

  var body: some View {
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

  let message: Message
}

private extension MessageContentText {

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
      .frame(
        width: Constant.textBackgroundArrowWidth,
        height: Constant.textBackgroundArrowWidth
      )
      .foregroundColor(textBackgroundColor)
      .rotationEffect(.init(degrees: 45))
    }
    .frame(
      width: Constant.textBackgroundArrowContainerWidth,
      height: Constant.textBackgroundArrowContainerHeight
    )
  }

  var textForegroundColor: Color {
    message.isOutgoingMsg ? Color.text_chat_outgoing_msg : Color.text_chat_incoming_msg
  }

  var textBackgroundColor: Color {
    message.isOutgoingMsg ? Color.bg_chat_outgoing_msg : Color.bg_chat_incoming_msg
  }
}

private extension MessageContentText {
  enum Constant {
    static let textFont: UIFont = .systemFont(ofSize: 16)
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
    VStack {
      MessageContentText(message: .textTemplate1)
      MessageContentText(message: .textTemplate2)
    }
    .padding(10)
    .background(.green)
    .onAppear { AppEnvironment.updateCurrentUser(.template1) }
  }
}
