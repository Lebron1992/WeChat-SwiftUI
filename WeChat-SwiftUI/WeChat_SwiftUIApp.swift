import SwiftUI
import SwiftUIRedux

@main
struct WeChat_SwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
        StoreProvider(store: store) {
            RootView()
              .onAppear(perform: styleApp)
        }
    }
  }

  private func styleApp() {
    let backImage = UIImage(named: "icons_outlined_back")
    let navBar = UINavigationBar.appearance()

    navBar.backIndicatorImage = backImage
    navBar.backIndicatorTransitionMaskImage = backImage
    navBar.shadowImage = UIImage()
    navBar.tintColor = UIColor(named: "text_primary")
    navBar.titleTextAttributes = [.foregroundColor: navBar.tintColor as Any]
  }
}
