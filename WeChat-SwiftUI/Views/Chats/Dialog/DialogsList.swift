import SwiftUI
import SwiftUIRedux

struct DialogsList: ConnectedView {
  struct Props {
    let dialogs: [Dialog]
  }

  func map(state: AppState, dispatch: @escaping Dispatch) -> Props {
    Props(
      dialogs: state.chatsState.dialogs
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
  }
}

struct DialogsList_Previews: PreviewProvider {
  static var previews: some View {
    DialogsList()
  }
}
