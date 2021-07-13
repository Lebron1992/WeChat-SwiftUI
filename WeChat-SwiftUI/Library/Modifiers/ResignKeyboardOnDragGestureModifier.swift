import SwiftUI

extension View {
  func resignKeyboardOnDragGesture(onResign: @escaping () -> Void = {}) -> some View {
    modifier(ResignKeyboardOnDragGesture(onResign: onResign))
  }
}

private struct ResignKeyboardOnDragGesture: ViewModifier {

  let onResign: () -> Void

  func body(content: Content) -> some View {
    content
      .gesture(
        DragGesture()
          .onChanged { _ in
            UIApplication.shared.endEditing(true)
            onResign()
          }
      )
  }
}
