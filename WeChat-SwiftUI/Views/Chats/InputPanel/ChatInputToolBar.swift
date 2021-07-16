import SwiftUI

struct ChatInputToolBar: View {

  @Binding
  var text: String

  @Binding
  var isVoiceButtonSelected: Bool

  @Binding
  var isExpressionButtonSelected: Bool

  @FocusState
  var isTextEditorFoucused: Bool

  var body: some View {
    HStack(alignment: .bottom, spacing: toolBarPadding) {
      Button {
        isVoiceButtonSelected.toggle()
        isExpressionButtonSelected = false
        isTextEditorFoucused = !isVoiceButtonSelected
      } label: {
        Image(isVoiceButtonSelected ? "icons_outlined_keyboard" : "icons_outlined_voice")
          .inputToolBarButtonStyle()
      }

      ZStack {
        Text(Strings.chat_hold_to_talk())
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.text_primary)
        TextEditor(text: $text)
          .font(Font(textFont as CTFont))
          .focused($isTextEditorFoucused)
          .opacity(isVoiceButtonSelected ? 0 : 1)
      }
      .frame(height: isVoiceButtonSelected ? toolBarMinHeight : textEditorHeight)
      .background(.bg_text_input)
      .cornerRadius(4)

      Button {
        isExpressionButtonSelected.toggle()
        isVoiceButtonSelected = false
      } label: {
        Image(isExpressionButtonSelected ? "icons_outlined_keyboard" : "icons_outlined_sticker")
          .inputToolBarButtonStyle()
      }

      Button {

      } label: {
        Image("icons_outlined_add")
          .inputToolBarButtonStyle()
      }
    }
    .foregroundColor(.text_primary)
    .padding(toolBarPadding)
    .background(.bg_info_150)
  }
}

private extension ChatInputToolBar {

  var textEditorHeight: CGFloat {

    let textEditorHorizontalInsets = textEditorInsets.leading + textEditorInsets.trailing
    let textEditorVerticalInsets = textEditorInsets.top + textEditorInsets.bottom
    let occupiedWidth: CGFloat = 5 * toolBarPadding + 3 * toolBarButtonWidth + textEditorHorizontalInsets
    let width = UIScreen.main.bounds.width - occupiedWidth

    let textHeight = text.height(withConstrainedWidth: width, font: textFont)
    let contentHeight = textHeight + textEditorVerticalInsets
    let maxHeight = ceil(maxLinesOfTextToDisplay * textFont.lineHeight + textEditorVerticalInsets)

    return min(max(toolBarMinHeight, contentHeight), maxHeight)
  }
}

private extension Image {
  func inputToolBarButtonStyle() -> some View {
    resize(.fill, .init(width: toolBarButtonWidth, height: toolBarButtonWidth))
      .padding(.vertical, (toolBarMinHeight - toolBarButtonWidth) * 0.5)
  }
}

// MARK: - Constants

private let maxLinesOfTextToDisplay: CGFloat = 4
private let toolBarPadding: CGFloat = 8
private let toolBarMinHeight: CGFloat = 36
private let toolBarButtonWidth: CGFloat = 26
private let textEditorInsets: EdgeInsets = .init(top: 8, leading: 5, bottom: 8, trailing: 5)
private let textFont: UIFont = .systemFont(ofSize: 16)

// MARK: - Previews

struct ChatInputToolBar_Previews: PreviewProvider {
  static var previews: some View {
    ChatInputToolBar(
      text: Binding<String>(get: { "" }, set: { _ in }),
      isVoiceButtonSelected: Binding<Bool>(get: { false }, set: { _ in }),
      isExpressionButtonSelected: Binding<Bool>(get: { false }, set: { _ in })
    )
  }
}
