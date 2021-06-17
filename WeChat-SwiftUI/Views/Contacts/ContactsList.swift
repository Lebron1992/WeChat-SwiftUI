import SwiftUI
import SwiftUIRedux

struct ContactsList: ConnectedView {
  struct Props {
    let contacts: Loadable<[User]>
    let loadContacts: () -> Void
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      contacts: state.contactsState.contacts,
      loadContacts: { dispatch(ContactsActions.LoadContacts()) }
    )
  }

  func body(props: Props) -> some View {
    switch props.contacts {
    case .notRequested:
      return AnyView(Text("").onAppear(perform: props.loadContacts))

    case let .isLoading(last, _):
      return AnyView(loadingView(last))

    case let .loaded(users):
      return AnyView(loadedView(users, showLoading: false))

    case let .failed(error):
      return AnyView(ErrorView(error: error, retryAction: props.loadContacts))
    }
  }
}

private extension ContactsList {

  func loadingView(_ previouslyLoaded: [User]?) -> some View {
    if let result = previouslyLoaded {
      return AnyView(loadedView(result, showLoading: true))
    } else {
      return AnyView(ActivityIndicatorView().padding())
    }
  }

  func loadedView(_ users: [User], showLoading: Bool) -> some View {
    ZStack {
      List {
        ForEach(users) { user in
          Text(user.name)
        }
      }
      if showLoading {
        ActivityIndicatorView(color: .gray)
          .padding()
      }
    }
  }
}

struct ContactsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactsList()
  }
}
