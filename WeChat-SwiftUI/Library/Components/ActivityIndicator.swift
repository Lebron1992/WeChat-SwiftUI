import SwiftUI

struct ActivityIndicator: View {

  private let style: Style

  init(style: Style = .medium) {
    self.style = style
  }

  var body: some View {
    ProgressView()
      .progressViewStyle(.circular)
      .scaleEffect(style.scale)
  }
}

extension ActivityIndicator {
  enum Style {
    case large
    case medium

    var scale: Double {
      switch self {
      case .large:
        return 1.8
      case .medium:
        return 1
      }
    }
  }
}

struct ActivityIndicator_Previews: PreviewProvider {
  static var previews: some View {
    ActivityIndicator(style: .medium)
    ActivityIndicator(style: .large)
  }
}
