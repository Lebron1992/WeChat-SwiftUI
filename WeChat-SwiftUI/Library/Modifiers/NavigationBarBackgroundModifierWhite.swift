import SwiftUI

private struct NavigationBarBackgroundModifierWhite: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(NavigationConfigurator(configure: { nav in
        nav.navigationBar.barTintColor = .white
      }))
  }
}

extension View {
  func navigationBarBackgroundWhite() -> some View {
    modifier(NavigationBarBackgroundModifierWhite())
  }
}
