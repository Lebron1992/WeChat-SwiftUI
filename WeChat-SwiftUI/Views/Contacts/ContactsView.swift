import SwiftUI
import ComposableArchitecture

struct ContactsView: View {

  var body: some View {
    WithViewStore(store, observe: { $0.contactsState.contacts }) { viewStore in
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
            contacts: viewStore.state,
            searchText: searchText,
            loadContacts: { viewStore.send(.contacts(.loadContacts)) },
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
      .environmentObject(StoreObservableObject(store: store))
    }
  }

  let store: Store<AppState, AppAction>

  @State
  private var isSearching = false

  @State
  private var searchText = ""
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(contactsState: .init(
        categories: [],
        contacts: .loaded([.template1, .template2]),
        officialAccounts: .notRequested
      )),
      reducer: appReducer
    )
    ContactsView(store: store)
  }
}
