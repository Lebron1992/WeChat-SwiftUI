import SwiftUI

extension View {
  func resignKeyboardOnDragGesture() -> some View {
    modifier(ResignKeyboardOnDragGesture())
  }
}

private struct ResignKeyboardOnDragGesture: ViewModifier {

  func body(content: Content) -> some View {
    content
      .gesture(
        DragGesture()
          .onChanged { _ in
            UIApplication.shared.endEditing(true)
          }
      )
  }
}
