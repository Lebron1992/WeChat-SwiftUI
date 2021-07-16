import SwiftUI

/* TODO:
--- 暂时无法使用代码调出键盘，升级到 iOS15 即可解决: 用 focus()
--- 输入框文字将表情替换成图片，`TextEditor` 暂时无法做到
--- 删除文字时识别是否删除表情，`TextEditor` 暂时无法做到
--- 在指定的光标位置插入表情，`TextEditor` 暂时无法做到
 */

struct ChatInputPanel: View {

  let dismissKeyboardOnTapOrDrag: Bool

  @State
  private var text: String = ""

  @State
  private var isVoiceButtonSelected = false

  @State
  private var isExpressionButtonSelected = false

  @FocusState
  private var isTextEditorFoucused: Bool

  // MARK: - Expression Preview

  @State
  private var selectedExpression: ExpressionSticker?

  @State
  private var selectedExpressionFrame: CGRect?

  // MARK: - Body

  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(spacing: 0) {
        Background(.bg_info_300)
          .frame(height: 0.8)

        ChatInputToolBar(
          text: $text,
          isVoiceButtonSelected: $isVoiceButtonSelected,
          isExpressionButtonSelected: $isExpressionButtonSelected,
          isTextEditorFoucused: _isTextEditorFoucused
        )

        if isExpressionButtonSelected {
          ExpressionKeyboard(
            selectedExpression: $selectedExpression,
            selectedExpressionFrame: $selectedExpressionFrame,
            onTapExpression: { exp in
              // TODO: 暂时无法获取 TextEditor 的光标位置，先默认添加到末尾
              text.append("[\(exp.desciptionForCurrentLanguage())]")
            })
            .frame(height: 300)
        }
      }

      if let exp = selectedExpression,
         let frame = selectedExpressionFrame {
        let width: CGFloat = 60
        let height: CGFloat = 120

        ExpressionPreview(expression: exp)
          .frame(width: width, height: height)
          .padding(.top, frame.maxY - height)
          .padding(.leading, frame.origin.x - (width - frame.width) * 0.5)
          .animation(nil, value: isExpressionButtonSelected)
      }
    }
    .coordinateSpace(name: Self.CoordinateSpace.panel.rawValue)
    .onChange(of: dismissKeyboardOnTapOrDrag, perform: { dismiss in
      guard dismiss else {
        return
      }
      if isTextEditorFoucused || isExpressionButtonSelected {
        isVoiceButtonSelected = false
        isExpressionButtonSelected = false
      }
    })
    .animation(.easeOut(duration: 0.25), value: isExpressionButtonSelected)
  }
}

extension ChatInputPanel {
  enum CoordinateSpace: String {
    case panel = "ChatInputPanel.panel"
  }
}

struct ChatInputPanel_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputPanel(dismissKeyboardOnTapOrDrag: true)
  }
}
