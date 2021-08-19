import SwiftUI

extension View {
  func resignKeyboardOnTap(onResign: @escaping () -> Void = {}) -> some View {
    modifier(ResignKeyboardOnTap(onResign: onResign))
  }
}

private struct ResignKeyboardOnTap: ViewModifier {

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
