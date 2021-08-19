import SwiftUI

extension View {
  func resignKeyboardOnDrag(onResign: @escaping () -> Void = {}) -> some View {
    modifier(ResignKeyboardOnDrag(onResign: onResign))
  }
}

private struct ResignKeyboardOnDrag: ViewModifier {

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
