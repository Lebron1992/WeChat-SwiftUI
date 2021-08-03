import SwiftUI
import SwiftUIRedux

struct ContentView: ConnectedView {

  @EnvironmentObject
  private var store: Store<AppState>

  struct Props {
    let signedInUser: User?
    let errorMessage: String?
    let loadUserSelf: () -> Void
  }

  func map(state: AppState, dispatch: @escaping Dispatch) -> Props {
    Props(
      signedInUser: state.authState.signedInUser,
      errorMessage: state.systemState.errorMessage,
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
    .alert(isPresented: showErrorMessage, content: {
      Alert(
        title: Text(""),
        message: Text(props.errorMessage ?? ""),
        dismissButton: .cancel(Text(Strings.general_ok()))
      )
    })
  }
}

private extension ContentView {
  var showErrorMessage: Binding<Bool> {
    Binding(
      get: { store.state.systemState.errorMessage != nil },
      set: { _ in
        store.dispatch(action: SystemActions.SetErrorMessage(message: nil))
      }
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
