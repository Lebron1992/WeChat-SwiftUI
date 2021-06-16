import SwiftUI
import SwiftUIRedux

@main
struct WeChat_SwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
        StoreProvider(store: store) {
            ContentView()
        }
    }
  }
}
