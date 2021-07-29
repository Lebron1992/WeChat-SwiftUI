import SwiftUI

extension View {
  func showLoading(show: Bool) -> some View {
    modifier(LoadingContainer(show: show))
  }
}

private struct LoadingContainer: ViewModifier {

  let style: UIActivityIndicatorView.Style
  let show: Bool

  init(style: UIActivityIndicatorView.Style = .large, show: Bool) {
    self.style = style
    self.show = show
  }

  func body(content: Content) -> some View {
    ZStack {
      content
      if show {
        Group {
          // Color.clear can't cover the content, so we use this to simulate it
          Color.white.opacity(0.001)
          ActivityIndicatorView(style: .large, color: .hex("#39393A")!)
            .padding(30)
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
      .showLoading(show: true)
  }
}
