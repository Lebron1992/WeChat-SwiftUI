import SwiftUI

struct ExpressionPreview: View {

  var body: some View {
      ZStack(alignment: .top) {
        ExpressionPreview.Bckground()
        VStack(spacing: 5) {
          image
          description
        }
        .padding(.top, Constant.topPadding)
        .padding(.horizontal, Constant.horizontalPadding)
      }
  }

  let expression: ExpressionSticker
}

private extension ExpressionPreview {

  private var image: some View {
    Image(expression.image)
      .resize(.fill, Constant.imageSize)
  }

  private var description: some View {
    Text(expression.desciptionForCurrentLanguage())
      .foregroundColor(.text_expression_preview)
      .lineLimit(1)
      .minimumScaleFactor(0.1)
      .frame(width: Constant.descriptionWidth, height: Constant.descriptionHeight)
  }
}

private extension ExpressionPreview {
  enum Constant {
    static let imageSize: CGSize = .init(width: 40, height: 40)
    static let descriptionWidth: CGFloat = 40
    static let descriptionHeight: CGFloat = 20
    static let horizontalPadding: CGFloat = 5
    static let topPadding: CGFloat = 10
  }
}

struct ExpressionPreview_Previews: PreviewProvider {
  static var previews: some View {
    ExpressionPreview(expression: .awesome)
      .frame(width: 64, height: 136)
      .padding(100)
      .background(.red)
  }
}
