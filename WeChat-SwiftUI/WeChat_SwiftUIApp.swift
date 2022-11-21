import SwiftUI
import ComposableArchitecture
import Firebase
import URLImage
import URLImageStore

@main
struct WeChat_SwiftUIApp: App {

  private let store: Store<AppState, AppAction>

  private let urlImageService = URLImageService(
    fileStore: URLImageFileStore(),
    inMemoryStore: URLImageInMemoryStore()
  )

  init() {
    FirebaseApp.configure()

    let restoredEnv = AppEnvironment.fromStorage(userDefaults: UserDefaults.standard)
    AppEnvironment.replaceCurrentEnvironment(restoredEnv)

    // 放在 FirebaseApp.configure() 之后初始化
    store = Store(
      initialState: AppState(),
      reducer: appReducer
    )

    styleApp()
  }

  var body: some Scene {
    WindowGroup {
      WithViewStore(store) { viewStore in
        ContentView(store: store)
          .environment(\.urlImageService, urlImageService)
          .onChange(of: viewStore.state, perform: { newValue in
            newValue.archive()
          })
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
