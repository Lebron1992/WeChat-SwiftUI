import Foundation

struct RootState {
  var selectedTab: TabBarItem
}

extension RootState: Equatable {
  static func == (lhs: RootState, rhs: RootState) -> Bool {
    lhs.selectedTab == rhs.selectedTab
  }
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
