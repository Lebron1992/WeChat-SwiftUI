import SwiftUI

extension View {
  func showLoading(_ show: Bool) -> some View {
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
          // Color.clear can't cover the content, so we use this to simulate it
          Color.white.opacity(0.001)
          ActivityIndicator()
            .background(Color.hex("#D2D3D5"))
            .cornerRadius(10)
            .opacity(show ? 1 : 0)
        }
      }
    }
  }
}

struct LoadingModifier_Previews: PreviewProvider {
  static var previews: some View {
    Color.white
      .showLoading(true)
  }
}
