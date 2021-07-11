import SwiftUI

extension View {
  func resignKeyboardOnTapGesture() -> some View {
    modifier(ResignKeyboardOnTapGesture())
  }
}

private struct ResignKeyboardOnTapGesture: ViewModifier {

  func body(content: Content) -> some View {
    content
      .gesture(
        TapGesture()
          .onEnded({
            UIApplication.shared.endEditing(true)
          })
      )
  }
}
