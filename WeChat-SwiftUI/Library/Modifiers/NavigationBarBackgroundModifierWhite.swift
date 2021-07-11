import SwiftUI

extension View {
  func navigationBarBackgroundWhite() -> some View {
    modifier(NavigationBarBackgroundModifierWhite())
  }
}

private struct NavigationBarBackgroundModifierWhite: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(NavigationConfigurator(configure: { nav in
        nav.navigationBar.barTintColor = .white
      }))
  }
}
