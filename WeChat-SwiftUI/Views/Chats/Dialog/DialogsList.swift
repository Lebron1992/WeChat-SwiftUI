import SwiftUI
import ComposableArchitecture

struct DialogsList: View {

  var body: some View {
    WithViewStore(store.wrappedValue, observe: { $0.chatsState.dialogs }) { viewStore in
      List {
        ForEach(viewStore.state) { dialog in
          NavigationRow(destination: DialogView(viewModel: .init(dialog: dialog))) {
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

  @EnvironmentObject
  private var store: StoreObservableObject<AppState, AppAction>

  @StateObject
  private var viewModel = DialogsListViewModel()
}

struct DialogsList_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(chatsState: .init(dialogs: [.template1], dialogMessages: [])),
      reducer: appReducer
    )
    DialogsList()
      .environmentObject(StoreObservableObject(store: store))
  }
}
