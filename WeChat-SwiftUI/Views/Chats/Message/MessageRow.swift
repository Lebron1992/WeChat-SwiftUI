import SwiftUI
import URLImage

struct MessageRow: View {
  let message: Message

  var body: some View {
    HStack(spacing: 8) {
      outgoingSendingIndicator
      HStack(alignment: .top, spacing: 8) {
        incomingAvatar
        messageContent
        outgoingAvatar
      }
    }
    .listRowBackground(Color.app_bg)
    .transition(.move(edge: .bottom))
  }
}

private extension MessageRow {

  @ViewBuilder
  var outgoingSendingIndicator: some View {
    if message.isOutgoingMsg {
      Spacer(minLength: Constant.spacingOfContentMaxWidthToEdge)
      sendingIndicator
    }
  }

  @ViewBuilder
  var incomingAvatar: some View {
    if message.isOutgoingMsg == false {
      avatar
    }
  }

  @ViewBuilder
  var outgoingAvatar: some View {
    if message.isOutgoingMsg {
      avatar
    } else {
      Spacer(minLength: Constant.spacingOfContentMaxWidthToEdge)
    }
  }

  var sendingIndicator: some View {
    Group {
      if message.isSending && message.isTextMsg {
        ActivityIndicator()
      } else {
        Color.clear
      }
    }
    // 让 ActivityIndicator 消失后仍然占据位置，防止 text 的大小发生改变
    .frame(width: Constant.sendingIndicatorWidth)
  }

  var avatar: some View {
    URLPlaceholderImage(message.sender.avatar, size: Constant.avatarSize) {
      Image.avatarPlaceholder
    }
    .background(.app_white)
    .cornerRadius(Constant.avatarCornerRadius)
  }

  @ViewBuilder
  var messageContent: some View {
    if message.isTextMsg {
      MessageContentText(message: message)
    } else if message.isImageMsg {
      MessageContentImage(message: message)
    }
  }
}

private extension MessageRow {
  enum Constant {
    static let spacingOfContentMaxWidthToEdge: CGFloat = 30
    static let sendingIndicatorWidth: CGFloat = 20

    static let avatarSize: CGSize = .init(width: 40, height: 40)
    static let avatarCornerRadius: CGFloat = 4
  }
}

struct MessageRow_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MessageRow(message: .textTemplate)
      MessageRow(message: .textTemplate2)
    }
    .padding(50)
    .background(.green)
    .onAppear { AppEnvironment.updateCurrentUser(.template) }
  }
}
