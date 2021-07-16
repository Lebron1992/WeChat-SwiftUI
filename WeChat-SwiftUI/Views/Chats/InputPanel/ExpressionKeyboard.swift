import SwiftUI

struct ExpressionKeyboard: View {

  @Binding
  var selectedExpression: ExpressionSticker?

  @Binding
  var selectedExpressionFrame: CGRect?

  let onTapExpression: (ExpressionSticker) -> Void

  // 定义为负的目的是：防止启动后 `selectedExpression` 和 `selectedExpressionFrame`
  // 在 `dragObserver(geometry: GeometryProxy, expression: ExpressionSticker)` 方法中被赋值
  @GestureState
  private var dragLocation: CGPoint = .init(x: -100, y: -100)

  private let expressions: [ExpressionSticker] = {
    let jsonPath = Bundle.main.path(forResource: "expressions", ofType: "json") ?? ""
    let array = try? JSONDecoder().decode(
      [ExpressionSticker].self,
      from: Data(contentsOf: URL(fileURLWithPath: jsonPath))
    )
    return array ?? []
  }()

  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 30, maximum: 30), spacing: 16)], spacing: 16) {
        ForEach(expressions, id: \.self) { exp in
          Button {
            onTapExpression(exp)
          } label: {
            Image(exp.image)
              .resize(.fill)
              .background(dragObserver(for: exp))
          }
        }
      }
      .coordinateSpace(name: Self.CoordinateSpace.expressionsGrid.rawValue)
      .delayTouches(for: 0.25)
      .gesture(
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
          .updating($dragLocation) { value, state, _ in
            state = value.location
          }
          .onEnded({ _ in
            selectedExpression = nil
            selectedExpressionFrame = nil
          })
      )
      .padding(.vertical, 20)
      .padding(.horizontal, 12)
    }
    .background(.bg_info_170)
  }

  private func dragObserver(for expression: ExpressionSticker) -> some View {
    GeometryReader { geometry in
      dragObserver(geometry: geometry, expression: expression)
    }
  }

  private func dragObserver(geometry: GeometryProxy, expression: ExpressionSticker) -> some View {

    let frameInPanel = geometry.frame(in: .named(ChatInputPanel.CoordinateSpace.panel.rawValue))
    let frame = geometry.frame(in: .named(Self.CoordinateSpace.expressionsGrid.rawValue))

    if frame.contains(dragLocation) {
      DispatchQueue.main.async {
        selectedExpression = expression
        selectedExpressionFrame = frameInPanel
      }
    }

    return Rectangle().fill(Color.clear)
  }
}

extension ExpressionKeyboard {
  enum CoordinateSpace: String {
    case expressionsGrid = "ExpressionKeyboard.expressionsGrid"
  }
}

struct ExpressionKeyboard_Previews: PreviewProvider {
  static var previews: some View {
    ExpressionKeyboard(
      selectedExpression: .init(get: { nil }, set: { _ in }),
      selectedExpressionFrame: .init(get: { nil }, set: { _ in }),
      onTapExpression: { _ in }
    )
  }
}
