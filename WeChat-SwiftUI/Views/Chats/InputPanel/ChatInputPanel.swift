import SwiftUI

/* TODO:
 --- 输入框文字将表情替换成图片，`TextEditor` 暂时无法做到
 --- 删除文字时识别是否删除表情，`TextEditor` 暂时无法做到
 --- 在指定的光标位置插入表情，`TextEditor` 暂时无法做到
 */

struct ChatInputPanel: View {

  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(spacing: 0) {
        Color.bg_info_300
          .frame(height: Constant.topLineHeight)
        inputToolBar
        expressionKeyboard
      }
      expressionPreview
    }
    .coordinateSpace(name: Self.CoordinateSpace.panel.rawValue)
    .animation(.easeOut(duration: 0.25), value: isExpressionButtonSelected)
    .onChange(of: dismissKeyboard, perform: handleDismissKeyboardChange(_:))
    .onChange(of: isTextEditorFocused) { if $0 { onInputStarted() } }
    .onChange(of: isExpressionButtonSelected) { if $0 { onInputStarted() } }
    .onChange(of: text) { newValue in
      if newValue.last == "\n" { // 点击发送
        // TODO: 当 onSubmit 可用时移除
        onSubmitText(newValue.trimmingCharacters(in: .whitespacesAndNewlines))
        text = ""
      }
    }
  }

  let dismissKeyboard: Bool
  let onInputStarted: () -> Void
  let onSubmitText: (String) -> Void
  let onAddButtonTapped: () -> Void

  @State
  private var text: String = ""

  @State
  private var isVoiceButtonSelected = false

  @State
  private var isExpressionButtonSelected = false

  @FocusState
  private var isTextEditorFocused: Bool

  // MARK: - Expression Preview

  @State
  private var selectedExpression: ExpressionSticker?

  @State
  private var selectedExpressionFrame: CGRect?
}

private extension ChatInputPanel {
  var inputToolBar: some View {
    ChatInputToolBar(
      text: $text,
      isVoiceButtonSelected: $isVoiceButtonSelected,
      isExpressionButtonSelected: $isExpressionButtonSelected,
      isTextEditorFocused: _isTextEditorFocused,
      onSubmit: { onSubmitText(text) },
      onAddButtonTapped: onAddButtonTapped
    )
  }

  @ViewBuilder
  var expressionKeyboard: some View {
    if isExpressionButtonSelected {
      ExpressionKeyboard(
        selectedExpression: $selectedExpression,
        selectedExpressionFrame: $selectedExpressionFrame,
        onTapExpression: { exp in
          // TODO: 暂时无法获取 TextEditor 的光标位置，先默认添加到末尾
          text.append("[\(exp.desciptionForCurrentLanguage())]")
        })
        .frame(height: Constant.expressionKeyboardHeight)
    }
  }

  @ViewBuilder
  var expressionPreview: some View {
    if let exp = selectedExpression,
       let frame = selectedExpressionFrame {

      let width = Constant.expressionPreviewSize.width
      let height = Constant.expressionPreviewSize.height

      ExpressionPreview(expression: exp)
        .frame(width: width, height: height)
        .padding(.top, frame.maxY - height)
        .padding(.leading, frame.origin.x - (width - frame.width) * 0.5)
        .animation(nil, value: isExpressionButtonSelected)
    }
  }

  func handleDismissKeyboardChange(_ dismiss: Bool) {
    guard dismiss else { return }
    if isTextEditorFocused || isExpressionButtonSelected {
      isVoiceButtonSelected = false
      isExpressionButtonSelected = false
    }
  }
}

extension ChatInputPanel {
  enum CoordinateSpace: String {
    case panel = "ChatInputPanel.panel"
  }
}

private extension ChatInputPanel {
  enum Constant {
    static let topLineHeight: CGFloat = 0.8
    static let expressionKeyboardHeight: CGFloat = 300
    static let expressionPreviewSize: CGSize = .init(width: 60, height: 120)
  }
}

struct ChatInputPanel_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputPanel(
      dismissKeyboard: true,
      onInputStarted: { },
      onSubmitText: { _ in },
      onAddButtonTapped: { }
    )
  }
}
