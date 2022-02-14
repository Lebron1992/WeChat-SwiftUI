import SwiftUI
import SwiftUIRedux

struct ContactsView: ConnectedView {

  @State
  private var isSearching = false

  @State
  private var searchText = ""

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
    NavigationView {
      VStack(spacing: 0) {
        SearchBar(
          searchText: $searchText,
          onEditingChanged: {
            isSearching = true
          },
          onCancelButtonTapped: {
            isSearching = false
          }
        )

        ContactsList(
          contacts: props.contacts,
          searchText: searchText,
          loadContacts: props.loadContacts,
          header: { () -> ContactCategoriesList? in
            if isSearching {
              return nil
            } else {
              return ContactCategoriesList()
            }
          },
          selectionDestination: {
            ContactDetail(contact: $0)
          }
        )

        Spacer(minLength: 0)
      }
      .navigationTitle(Strings.tabbar_contacts())
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: Image("icons_outlined_add_friends"))
      .navigationBarHidden(isSearching)
    }
    .navigationViewStyle(.stack)
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
