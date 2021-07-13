import SwiftUI

struct ExpressionKeyboard: View {

  let onTapExpression: (ExpressionSticker) -> Void

  private let expressions: [ExpressionSticker] = {
    let jsonPath = Bundle.main.path(forResource: "expressions", ofType: "json") ?? ""
    let array = try? JSONDecoder().decode(
      [ExpressionSticker].self,
      from: Data(contentsOf: URL(fileURLWithPath: jsonPath))
    )
    return array ?? []
  }()

  // 定义为负的目的是：防止启动后 `selectedExpression` 和 `selectedExpressionFrame`
  // 在 `dragObserver(geometry: GeometryProxy, expression: ExpressionSticker)` 方法中被赋值
  @GestureState
  private var dragLocation: CGPoint = .init(x: -100, y: -100)

  @State
  private var isPreviewGestureEnded = true

  @State
  private var selectedExpression: ExpressionSticker?

  @State
  private var selectedExpressionFrame: CGRect?

  var body: some View {
    ScrollView {
      ZStack(alignment: .topLeading) {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 30, maximum: 30), spacing: 16)], spacing: 16) {
          ForEach(expressions, id: \.self) { exp in
            ZStack {
              Button {
                onTapExpression(exp)
              } label: {
                Image(exp.image)
                  .resize(.fill)
                  .background(dragObserver(for: exp))
              }
            }
          }
        }
        .coordinateSpace(name: "LazyVGrid")
        .delayTouches(for: 0.25)
        .gesture(
          DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .updating($dragLocation) { value, state, _ in
              state = value.location
            }
            .onChanged({ _ in
                isPreviewGestureEnded = false
            })
            .onEnded({ _ in
              isPreviewGestureEnded = true
              selectedExpression = nil
              selectedExpressionFrame = nil
            })
        )

        if isPreviewGestureEnded == false,
           let exp = selectedExpression,
           let frame = selectedExpressionFrame {

          let width: CGFloat = 60
          let height: CGFloat = 120

          ExpressionPreview(expression: exp)
            .frame(width: width, height: height)
            .padding(.top, frame.maxY - height)
            .padding(.leading, frame.origin.x - (width - frame.width) * 0.5)
        }
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 12)
    }
    .background(Color.bg_info_170)
  }

  private func dragObserver(for expression: ExpressionSticker) -> some View {
    GeometryReader { geometry in
      dragObserver(geometry: geometry, expression: expression)
    }
  }

  private func dragObserver(geometry: GeometryProxy, expression: ExpressionSticker) -> some View {
    let frame = geometry.frame(in: .named("LazyVGrid"))
    if frame.contains(dragLocation) {
      DispatchQueue.main.async {
        selectedExpression = expression
        selectedExpressionFrame = frame
      }
    }
    return Rectangle().fill(Color.clear)
  }
}

struct ExpressionKeyboard_Previews: PreviewProvider {
  static var previews: some View {
    ExpressionKeyboard(onTapExpression: { _ in })
  }
}
