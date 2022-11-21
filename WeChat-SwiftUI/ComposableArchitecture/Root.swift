import ComposableArchitecture

enum RootAction: Equatable {
  case setSelectedTab(TabBarItem)
}

struct RootReducer: ReducerProtocol {
  func reduce(into state: inout RootState, action: RootAction) -> EffectTask<RootAction> {
    switch action {
    case let .setSelectedTab(tab):
      state.selectedTab = tab
      return .none
    }
  }
}
