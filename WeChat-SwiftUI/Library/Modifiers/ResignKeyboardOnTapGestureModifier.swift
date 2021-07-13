import SwiftUI

extension View {
  func resignKeyboardOnTapGesture(onResign: @escaping () -> Void = {}) -> some View {
    modifier(ResignKeyboardOnTapGesture(onResign: onResign))
  }
}

private struct ResignKeyboardOnTapGesture: ViewModifier {

  let onResign: () -> Void

  func body(content: Content) -> some View {
    content
      .gesture(
        TapGesture()
          .onEnded({
            UIApplication.shared.endEditing(true)
            onResign()
          })
      )
  }
}
