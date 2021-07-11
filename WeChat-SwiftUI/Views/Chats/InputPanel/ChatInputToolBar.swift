import SwiftUI

struct ChatInputToolBar: View {

  @Binding
  var text: String

    var body: some View {
      HStack(alignment: .bottom, spacing: toolBarPadding) {
        Button {

        } label: {
          Image("icons_outlined_voice")
            .inputToolBarButtonStyle()
        }

        TextEditor(text: $text)
          .font(Font(textFont as CTFont))
          .frame(height: textEditorHeight)
          .background(Color.text_input_bg)
          .cornerRadius(4)

        Button {

        } label: {
          Image("icons_outlined_sticker")
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
      .background(Color.bg_info_150)
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
      ChatInputToolBar(text: Binding<String>(get: { "" }, set: { _ in }))
    }
}
