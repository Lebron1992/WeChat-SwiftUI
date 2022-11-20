import SwiftUI

struct ChatInputToolBar: View {

  var body: some View {
    HStack(alignment: .bottom, spacing: Constant.toolBarPadding) {
      voiceButton
      textEditor
      expressionButton
      addButton
    }
    .foregroundColor(.text_primary)
    .padding(Constant.toolBarPadding)
    .background(.bg_info_150)
    .onChange(of: isTextEditorFocused) { newValue in
      if newValue {
        isExpressionButtonSelected = false
      }
    }
  }

  @Binding
  var text: String

  @Binding
  var isVoiceButtonSelected: Bool

  @Binding
  var isExpressionButtonSelected: Bool

  @FocusState
  var isTextEditorFocused: Bool

  let onSubmit: () -> Void

  let onAddButtonTapped: () -> Void
}

private extension ChatInputToolBar {

  private var voiceButton: some View {
    Button {
      isVoiceButtonSelected.toggle()
      isExpressionButtonSelected = false
      isTextEditorFocused = !isVoiceButtonSelected
    } label: {
      Image(isVoiceButtonSelected ? "icons_outlined_keyboard" : "icons_outlined_voice")
        .inputToolBarButtonStyle()
    }
  }

  private var textEditor: some View {
    ZStack {
      Text(Strings.chat_hold_to_talk())
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(.text_primary)
      TextEditor(text: $text)
        .font(Font(Constant.textFont as CTFont))
        .submitLabel(.send) // TODO: 暂时无效，等待苹果修复
        .background(.app_white)
        .focused($isTextEditorFocused)
        .opacity(isVoiceButtonSelected ? 0 : 1)
        .onSubmit(onSubmit) // TODO: 暂时无效，等待苹果修复
    }
    .frame(height: isVoiceButtonSelected ? Constant.toolBarMinHeight : textEditorHeight)
    .background(.bg_text_input)
    .cornerRadius(4)
  }

  private var expressionButton: some View {
    Button {
      isExpressionButtonSelected.toggle()
      isVoiceButtonSelected = false
      isTextEditorFocused = !isExpressionButtonSelected
    } label: {
      Image(isExpressionButtonSelected ? "icons_outlined_keyboard" : "icons_outlined_sticker")
        .inputToolBarButtonStyle()
    }
  }

  private var addButton: some View {
    Button {
      onAddButtonTapped()
    } label: {
      Image("icons_outlined_add")
        .inputToolBarButtonStyle()
    }
  }
}

private extension ChatInputToolBar {

  var textEditorHeight: CGFloat {

    let textEditorInsets = Constant.textEditorInsets
    let textEditorHorizontalInsets = textEditorInsets.leading + textEditorInsets.trailing
    let textEditorVerticalInsets = textEditorInsets.top + textEditorInsets.bottom
    let occupiedWidth: CGFloat = 5 * Constant.toolBarPadding +
                                 3 * Constant.toolBarButtonWidth +
                                 textEditorHorizontalInsets
    let width = UIScreen.main.bounds.width - occupiedWidth

    let textHeight = text.height(withConstrainedWidth: width, font: Constant.textFont)
    let contentHeight = textHeight + textEditorVerticalInsets
    let maxHeight = ceil(Constant.maxLinesOfTextToDisplay * Constant.textFont.lineHeight + textEditorVerticalInsets)

    return min(max(Constant.toolBarMinHeight, contentHeight), maxHeight)
  }
}

private extension Image {
  func inputToolBarButtonStyle() -> some View {
    typealias Constant = ChatInputToolBar.Constant
    let size = CGSize(
      width: Constant.toolBarButtonWidth,
      height: Constant.toolBarButtonWidth
    )
    let padding = (Constant.toolBarMinHeight - Constant.toolBarButtonWidth) * 0.5
    return resize(.fill, size)
      .padding(.vertical, padding)
  }
}

// MARK: - Constants
private extension ChatInputToolBar {
  enum Constant {
    static let maxLinesOfTextToDisplay: CGFloat = 4
    static let toolBarPadding: CGFloat = 8
    static let toolBarMinHeight: CGFloat = 36
    static let toolBarButtonWidth: CGFloat = 26
    static let textEditorInsets: EdgeInsets = .init(top: 8, leading: 5, bottom: 8, trailing: 5)
    static let textFont: UIFont = .systemFont(ofSize: 16)
  }
}

// MARK: - Previews
struct ChatInputToolBar_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputToolBar(
      text: .constant(""),
      isVoiceButtonSelected: .constant(false),
      isExpressionButtonSelected: .constant(false),
      onSubmit: { },
      onAddButtonTapped: { }
    )
  }
}
