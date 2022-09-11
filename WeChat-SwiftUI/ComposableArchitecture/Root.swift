import ComposableArchitecture

enum RootAction: Equatable {
  case setSelectedTab(TabBarItem)
}

let rootReducer = Reducer<RootState, RootAction, Environment> { state, action, _ in
  switch action {
  case let .setSelectedTab(tab):
    state.selectedTab = tab
    return .none
  }
}
