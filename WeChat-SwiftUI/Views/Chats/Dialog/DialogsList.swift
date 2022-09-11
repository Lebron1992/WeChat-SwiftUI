import SwiftUI
import ComposableArchitecture

struct DialogsList: View {

  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEach(viewStore.chatsState.dialogs) { dialog in
          NavigationRow(destination: DialogView(store: store, viewModel: .init(dialog: dialog))) {
            DialogRow(dialog: dialog)
          }
        }
        .listRowInsets(.zero)
      }
      .listStyle(.plain)
      .onAppear(perform: { viewStore.send(.chats(.loadDialogs)) })
      .onChange(of: viewModel.dialogChanges, perform: {
        viewStore.send(.chats(.updateDialogs($0)))
      })
    }
  }

  let store: Store<AppState, AppAction>

  @StateObject
  private var viewModel = DialogsListViewModel()
}

struct DialogsList_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(chatsState: .init(dialogs: [.template1], dialogMessages: [])),
      reducer: appReducer,
      environment: AppEnvironment.current
    )
    DialogsList(store: store)
  }
}
