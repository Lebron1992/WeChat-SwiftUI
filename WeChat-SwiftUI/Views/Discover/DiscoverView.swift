import SwiftUI
import ComposableArchitecture

struct DiscoverView: View {
  var body: some View {
    NavigationView {
      DiscoverList(store: store)
        .navigationTitle(Strings.tabbar_discover())
        .navigationBarTitleDisplayMode(.inline)
    }
    .navigationViewStyle(.stack)
  }

  let store: Store<DiscoverState, Never>
}

struct DiscoverView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(),
      reducer: appReducer
    )
      .scope(state: \.discoverState)
      .actionless
    DiscoverView(store: store)
  }
}
