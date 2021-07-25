import SwiftUI
import SwiftUIRedux
import Firebase
import URLImage
import URLImageStore

private let urlImageService = URLImageService(
  fileStore: URLImageFileStore(),
  inMemoryStore: URLImageInMemoryStore()
)

@main
struct WeChat_SwiftUIApp: App {

  private let cancelBag = CancelBag()

  init() {
    FirebaseApp.configure()

    let restoredEnv = AppEnvironment.fromStorage(userDefaults: UserDefaults.standard)
    AppEnvironment.replaceCurrentEnvironment(restoredEnv)

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
  }

  var body: some Scene {
    WindowGroup {
      StoreProvider(store: store) {
        ContentView()
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
  }
}
