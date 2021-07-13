import SwiftUI

/* TODO:
 1. 输入框弹出时，背后有白色背景
 2. 暂时无法使用代码调出键盘，升级到 iOS15 即可解决: 用 focus()
 */

struct ChatInputPanel: View {

  let dismissKeyboardOnTapOrDrag: Bool

  @State
  private var text: String = ""

  @State
  private var isVoiceButtonSelected = false

  @State
  private var isExpressionButtonSelected = false

  var body: some View {
    VStack(spacing: 0) {
      Background(.bg_info_300)
        .frame(height: 0.8)

      ChatInputToolBar(
        text: $text,
        isVoiceButtonSelected: $isVoiceButtonSelected,
        isExpressionButtonSelected: $isExpressionButtonSelected
      )

      if isExpressionButtonSelected {
        ExpressionKeyboard()
          .frame(height: 300)
          .animation(.none)
      }
    }
    .onChange(of: dismissKeyboardOnTapOrDrag, perform: { dismiss in
      if dismiss {
        isVoiceButtonSelected = false
        isExpressionButtonSelected = false
      }
    })
    .animation(.easeOut(duration: 0.25))
  }
}

struct ChatInputPanel_Previews: PreviewProvider {
    static var previews: some View {
      ChatInputPanel(dismissKeyboardOnTapOrDrag: true)
    }
}
