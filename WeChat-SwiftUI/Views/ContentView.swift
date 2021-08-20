import SwiftUI
import SwiftUIRedux

struct ContentView: ConnectedView {

  @EnvironmentObject
  private var store: Store<AppState>

  struct Props {
    let signedInUser: User?
    let loadUserSelf: () -> Void
  }

  func map(state: AppState, dispatch: @escaping Dispatch) -> Props {
    Props(
      signedInUser: state.authState.signedInUser,
      loadUserSelf: { dispatch(AuthActions.LoadUserSelf()) }
    )
  }

  func body(props: Props) -> some View {
    Group {
      if props.signedInUser == nil {
        OnboardingView()
      } else {
        RootView()
          .onAppear(perform: props.loadUserSelf)
      }
    }
    .alert(item: errorMessage) {
      Alert(
        title: Text(""),
        message: Text($0),
        dismissButton: .cancel(Text(Strings.general_ok()))
      )
    }
  }
}

private extension ContentView {
  var errorMessage: Binding<String?> {
    Binding(
      get: { store.state.systemState.errorMessage },
      set: { _ in store.dispatch(action: SystemActions.SetErrorMessage(message: nil)) }
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
