import SwiftUI
import ComposableArchitecture

struct ChatsView: View {

  var body: some View {
    NavigationView {
      DialogsList()
        .navigationTitle(Strings.tabbar_chats())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Image("icons_outlined_add"))
    }
    .navigationViewStyle(.stack)
    .environmentObject(StoreObservableObject(store: store))
  }

  let store: Store<AppState, AppAction>
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
      let store = Store(
        initialState: AppState(chatsState: .init(dialogs: [.template1, .template2], dialogMessages: [])),
        reducer: appReducer
      )
      ChatsView(store: store)
    }
}
