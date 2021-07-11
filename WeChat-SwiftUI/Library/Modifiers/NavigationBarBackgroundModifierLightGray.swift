import SwiftUI

extension View {
  func navigationBarBackgroundLightGray() -> some View {
    modifier(NavigationBarBackgroundModifierLightGray())
  }
}

private struct NavigationBarBackgroundModifierLightGray: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(NavigationConfigurator(configure: { nav in
        nav.navigationBar.barTintColor = .app_bg
      }))
  }
}
