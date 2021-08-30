import SwiftUI
import SwiftUIRedux

struct DialogsList: ConnectedView {
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
        NavigationRow(destination: DialogView(dialog: dialog)) {
          DialogRow(dialog: dialog)
        }
      }
      .listRowInsets(.zero)
    }
    .background(.app_bg)
    .listStyle(.plain)
    .onAppear(perform: props.loadDialogs)
  }
}

struct DialogsList_Previews: PreviewProvider {
  static var previews: some View {
    DialogsList()
  }
}
