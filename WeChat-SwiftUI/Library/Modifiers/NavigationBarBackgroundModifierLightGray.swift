import SwiftUI

private struct NavigationBarBackgroundModifierLightGray: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(NavigationConfigurator(configure: { nav in
        nav.navigationBar.barTintColor = UIColor(named: "bg_info_200")
      }))
  }
}

extension View {
  func navigationBarBackgroundLightGray() -> some View {
    modifier(NavigationBarBackgroundModifierLightGray())
  }
}
