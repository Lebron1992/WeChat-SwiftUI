import SwiftUI

struct ChatView: View {
  var body: some View {
    VStack(spacing: 0) {
      List {

      }
      .resignKeyboardOnTapGesture()
      .resignKeyboardOnDragGesture()

      ChatInputPanel()
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
