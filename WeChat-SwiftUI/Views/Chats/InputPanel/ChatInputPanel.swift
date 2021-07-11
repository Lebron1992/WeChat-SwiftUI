import SwiftUI

/* TODO:
 1. 输入框弹出时，背后有白色背景
 */

struct ChatInputPanel: View {

  @State
  private var text: String = ""

  var body: some View {
    VStack(spacing: 0) {
      Background(.bg_info_300)
        .frame(height: 0.8)

      ChatInputToolBar(text: $text)

      ExpressionKeyboard()
        .frame(height: 300)
        .animation(.none)
    }
    .animation(.easeOut(duration: 0.25))
  }
}

struct ChatInputPanel_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputPanel()
    }
}
