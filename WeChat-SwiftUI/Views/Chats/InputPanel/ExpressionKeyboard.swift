import SwiftUI

struct ExpressionKeyboard: View {

  var body: some View {
    ScrollView {
      expressionGrid
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
        .padding(.horizontal, Constant.expressionsGridHorizontalPadding)
        .padding(.vertical, Constant.expressionsGridVerticalPadding)
    }
    .background(.bg_info_170)
  }

  @Binding
  var selectedExpression: ExpressionSticker?

  /// 被选中的 expression 在 ChatInputPanel 中的 frame
  @Binding
  var selectedExpressionFrame: CGRect?

  let onTapExpression: (ExpressionSticker) -> Void

  // 定义为负的目的是：防止启动后 `selectedExpression` 和 `selectedExpressionFrame`
  // 在 `dragObserver(geometry: GeometryProxy, expression: ExpressionSticker)` 方法中被赋值
  @GestureState
  private var dragLocation: CGPoint = .init(x: -100, y: -100)

  private let expressions: [ExpressionSticker] = {
    let jsonPath = Bundle.main.path(forResource: "expressions", ofType: "json") ?? ""
    let array = try? WeChat_SwiftUI.Constant.jsonDecoder.decode(
      [ExpressionSticker].self,
      from: Data(contentsOf: URL(fileURLWithPath: jsonPath))
    )
    return array ?? []
  }()
}

private extension ExpressionKeyboard {

  @ViewBuilder
  private var expressionGrid: some View {
    let gridItem = GridItem(
      .adaptive(
        minimum: Constant.expressionItemWidth,
        maximum: Constant.expressionItemHeight
      ),
      spacing: Constant.expressionItemSpacing
    )
    LazyVGrid(columns: [gridItem], spacing: Constant.expressionItemSpacing) {
      ForEach(expressions, id: \.self) {
        expressionItem(for: $0)
      }
    }
  }

  private func expressionItem(for expression: ExpressionSticker) -> some View {
    Button {
      onTapExpression(expression)
    } label: {
      Image(expression.image)
        .resize(.fill)
        .background(dragObserver(for: expression))
    }
  }
}

// MARK: - Drag Observer
private extension ExpressionKeyboard {

  func dragObserver(for expression: ExpressionSticker) -> some View {
    GeometryReader { geometry in
      dragObserver(geometry: geometry, expression: expression)
    }
  }

  func dragObserver(geometry: GeometryProxy, expression: ExpressionSticker) -> some View {

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

private extension ExpressionKeyboard {
  enum Constant {
    static let expressionItemWidth: CGFloat = 30
    static let expressionItemHeight: CGFloat = expressionItemWidth
    static let expressionItemSpacing: CGFloat = 16
    static let expressionsGridHorizontalPadding: CGFloat = 12
    static let expressionsGridVerticalPadding: CGFloat = 20
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
