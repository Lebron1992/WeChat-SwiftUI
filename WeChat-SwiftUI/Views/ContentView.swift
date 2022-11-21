import SwiftUI
import ComposableArchitecture

struct ContentView: View {

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      let errorMessage = Binding<String?>(
        get: { viewStore.systemState.errorMessage },
        set: { _ in viewStore.send(AppAction.system(.setErrorMessage(nil))) }
      )
      Group {
        if viewStore.authState.signedInUser == nil {
          OnboardingView(store: store)
        } else {
          RootView(store: store)
            .onAppear { viewStore.send(AppAction.auth(.loadUserSelf)) }
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

  let store: Store<AppState, AppAction>
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView(store: Store(
        initialState: AppState(),
        reducer: appReducer
      ))
      ContentView(store: Store(
        initialState: AppState(
          authState: .init(signedInUser: .template1),
          chatsState: .init(dialogs: [.template1, .template2], dialogMessages: []),
          contactsState: .init(
            categories: ContactCategory.allCases,
            contacts: .loaded([.template1, .template2]),
            officialAccounts: .loaded([.template1, .template2])
          )
        ),
        reducer: appReducer
      ))
    }
  }
}
