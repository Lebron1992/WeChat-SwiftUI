import SwiftUI

struct ExpressionPreview: View {

  let expression: ExpressionSticker

  var body: some View {
      ZStack(alignment: .top) {
        ExpressionPreview.Bckground()

        VStack(spacing: 5) {
          Image(expression.image)
            .resize(.fill, .init(width: 40, height: 40))

          Text(expression.desciptionForCurrentLanguage())
            .foregroundColor(.text_expression_preview)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(width: 40, height: 20)
        }
        .padding(.top, 10)
        .padding(.horizontal, 5)
      }
  }
}

extension ExpressionPreview {

  struct Bckground: View {

    var body: some View {
      GeometryReader { geoy in
        Path { path in
          let width: CGFloat = geoy.size.width
          let height = geoy.size.height
          path.move(
            to: CGPoint(
              x: width * 0.8,
              y: 0
            )
          )

          segments(for: geoy.size).forEach { segment in
            path.addLine(
              to: CGPoint(
                x: width * segment.line.x,
                y: height * segment.line.y
              )
            )

            path.addQuadCurve(
              to: CGPoint(
                x: width * segment.curve.x,
                y: height * segment.curve.y
              ),
              control: CGPoint(
                x: width * segment.control.x,
                y: height * segment.control.y
              )
            )
          }
        }
        .fill(Color.bg_expression_preview)
      }
    }

    struct Segment {
      let line: CGPoint
      let curve: CGPoint
      let control: CGPoint
    }

    // swiftlint:disable colon
    private func segments(for size: CGSize) -> [Segment] {
      let whRatio = size.width / size.height
      return [
        Segment(
          line:    CGPoint(x: 0.35, y: 0.00),
          curve:   CGPoint(x: 0.00, y: 0.35 * whRatio),
          control: CGPoint(x: 0.00, y: 0.00)
        ),
        Segment(
          line:    CGPoint(x: 0.000, y: 0.45),
          curve:   CGPoint(x: 0.050, y: 0.55),
          control: CGPoint(x: 0.005, y: 0.50)
        ),
        Segment(
          line:    CGPoint(x: 0.05, y: 0.55),
          curve:   CGPoint(x: 0.20, y: 0.85),
          control: CGPoint(x: 0.21, y: 0.70)
        ),
        Segment(
          line:    CGPoint(x: 0.20, y: 1 - 0.15 * whRatio),
          curve:   CGPoint(x: 0.30, y: 1.00),
          control: CGPoint(x: 0.20, y: 1.00)
        ),
        Segment(
          line:    CGPoint(x: 0.70, y: 1.00),
          curve:   CGPoint(x: 0.80, y: 1 - 0.15 * whRatio),
          control: CGPoint(x: 0.80, y: 1.00)
        ),
        Segment(
          line:    CGPoint(x: 0.80, y: 0.85),
          curve:   CGPoint(x: 0.95, y: 0.55),
          control: CGPoint(x: 0.79, y: 0.70)
        ),
        Segment(
          line:    CGPoint(x: 0.950, y: 0.55),
          curve:   CGPoint(x: 1.000, y: 0.45),
          control: CGPoint(x: 0.995, y: 0.50)
        ),
        Segment(
          line:    CGPoint(x: 1.00, y: 0.35 * whRatio),
          curve:   CGPoint(x: 0.65, y: 0.00),
          control: CGPoint(x: 1.00, y: 0.00)
        )
      ]
    }
  }
}

struct ExpressionPreview_Previews: PreviewProvider {
  static var previews: some View {
    ExpressionPreview(expression: .template)
      .frame(width: 64, height: 136)
      .padding(100)
      .background(.red)
  }
}
