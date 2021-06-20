import SwiftUIRedux

final class MockStore: Store<AppState> {

  private(set) var actions: [Action] = []

  override func dispatch(action: Action) {
    actions.append(action)
    super.dispatch(action: action)
  }
}
