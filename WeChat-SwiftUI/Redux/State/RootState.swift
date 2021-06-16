import Foundation

struct RootState {
  var selectedTab: TabBarItem
}

#if DEBUG
extension RootState {
  static var preview: RootState {
    RootState(
      selectedTab: .chats
    )
  }
}
#endif
