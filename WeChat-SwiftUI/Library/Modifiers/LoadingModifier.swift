import SwiftUI

extension View {
  func showLoading(show: Bool) -> some View {
    modifier(LoadingContainer(show: show))
  }
}

private struct LoadingContainer: ViewModifier {

  let show: Bool

  func body(content: Content) -> some View {
    ZStack {
      content
      if show {
        Group {
          Color.black.opacity(0.3)
          ActivityIndicatorView(style: .large, color: .hex("#39393A")!)
            .padding(30)
            .background(Color.hex("#D2D3D5"))
            .cornerRadius(10)
            .opacity(show ? 1 : 0)
        }
        .ignoresSafeArea()
      }
    }
  }
}

struct LoadingModifier_Previews: PreviewProvider {
  static var previews: some View {
    Color.white
      .showLoading(show: true)
  }
}