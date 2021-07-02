import SwiftUI
import SwiftUIRedux
import URLImage
import URLImageStore

let urlImageService = URLImageService(
  fileStore: URLImageFileStore(),
  inMemoryStore: URLImageInMemoryStore()
)

@main
struct WeChat_SwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      StoreProvider(store: store) {
        RootView()
          .environment(\.urlImageService, urlImageService)
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
    navBar.tintColor = .text_primary
    navBar.titleTextAttributes = [.foregroundColor: navBar.tintColor as Any]
    navBar.isTranslucent = false

    UITableView.appearance().backgroundColor = UIColor(.app_bg)
  }
}
