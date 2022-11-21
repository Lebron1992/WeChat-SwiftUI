import SwiftUI
import ComposableArchitecture

struct MyProfileView: View {

  var body: some View {
    WithViewStore(store) { viewStore in
      if let user = viewStore.signedInUser {
        List {
          ForEach(Row.allCases, id: \.self) { row in
            ProfileRow(row: row, user: user)
          }
          .listRowBackground(Color.app_white)
        }
        .background(.app_bg)
        .listStyle(.plain)
        .navigationTitle(Strings.me_my_profile_title())
      } else {
        EmptyView()
      }
    }
  }

  let store: Store<AuthState, AppAction>
}

struct MyProfileView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(authState: .init(signedInUser: .template1)),
      reducer: appReducer
    )
      .scope(state: \.authState)
    MyProfileView(store: store)
  }
}
