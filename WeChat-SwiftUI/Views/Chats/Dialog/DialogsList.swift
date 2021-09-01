import SwiftUI
import SwiftUIRedux

struct DialogsList: ConnectedView {

  @EnvironmentObject
  private var store: Store<AppState>

  @StateObject
  private var viewModel = DialogsListViewModel()

  struct Props {
    let dialogs: [Dialog]
    let loadDialogs: () -> Void
  }

  func map(state: AppState, dispatch: @escaping Dispatch) -> Props {
    Props(
      dialogs: state.chatsState.dialogs,
      loadDialogs: { dispatch(ChatsActions.LoadDialogs()) }
    )
  }

  func body(props: Props) -> some View {
    List {
      ForEach(props.dialogs) { dialog in
        NavigationRow(destination: DialogView(viewModel: .init(dialog: dialog))) {
          DialogRow(dialog: dialog)
        }
      }
      .listRowInsets(.zero)
    }
    .background(.app_bg)
    .listStyle(.plain)
    .onAppear(perform: props.loadDialogs)
    .onChange(of: viewModel.dialogChanges, perform: handleDialogChanges(_:))
  }
}

// MARK: - Helper Methods
private extension DialogsList {
  func handleDialogChanges(_ dialogChanges: [DialogChange]) {
    store.dispatch(action: ChatsActions.UpdateDialogs(dialogChanges: dialogChanges))
  }
}

struct DialogsList_Previews: PreviewProvider {
  static var previews: some View {
    DialogsList()
  }
}
