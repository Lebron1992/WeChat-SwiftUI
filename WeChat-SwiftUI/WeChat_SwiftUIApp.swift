import SwiftUI
import SwiftUIRedux
import Firebase
import URLImage
import URLImageStore

@main
struct WeChat_SwiftUIApp: App {

  private let cancelBag = CancelBag()

  private let urlImageService = URLImageService(
    fileStore: URLImageFileStore(),
    inMemoryStore: URLImageInMemoryStore()
  )

  init() {
    FirebaseApp.configure()

    let restoredEnv = AppEnvironment.fromStorage(userDefaults: UserDefaults.standard)
    AppEnvironment.replaceCurrentEnvironment(restoredEnv)

    // 保存 AppState
    let appState = AppState()
    store.$state
      .scan((appState, appState)) { result, newState in
        let oldState = result.1
        if oldState.archivePropertiesEqualTo(newState) == false {
          newState.archive()
        }
        return (oldState, newState)
      }
      .sink(receiveValue: { _ in })
      .store(in: cancelBag)

    styleApp()
  }

  var body: some Scene {
    WindowGroup {
      StoreProvider(store: store) {
        ContentView()
          .environment(\.urlImageService, urlImageService)
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

    UITabBar.appearance().unselectedItemTintColor = .text_primary
    UITableView.appearance().sectionHeaderTopPadding = 0
  }
}
