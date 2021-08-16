import SwiftUI

extension View {
  func asAnyView() -> AnyView {
    AnyView(self)
  }
}
