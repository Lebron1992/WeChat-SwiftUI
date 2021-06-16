import Foundation
import SwiftUIRedux

struct AppState: ReduxState {
  var rootState: RootState

  init() {
    rootState = RootState(selectedTab: .chats)
  }

  #if DEBUG
  init(
    rootState: RootState
  ) {
    self.rootState = rootState
  }
  #endif
}

#if DEBUG
extension AppState {
  static var preview: AppState {
    AppState(
      rootState: .preview
    )
  }
}
#endif
