import SwiftUI

struct ChatView: View {
  var body: some View {
    VStack(spacing: 0) {
      List {

      }
      .resignKeyboardOnTapGesture()
      .resignKeyboardOnDragGesture()

      ChatInputToolBar()
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
