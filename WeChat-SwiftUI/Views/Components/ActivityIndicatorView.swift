import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

  private let style: UIActivityIndicatorView.Style
  private let color: Color

  init(style: UIActivityIndicatorView.Style = .medium, color: Color = .white) {
    self.style = style
    self.color = color
  }

  func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(style: style)
    indicator.color = UIColor(color)
    return indicator
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
    uiView.startAnimating()
  }
}
