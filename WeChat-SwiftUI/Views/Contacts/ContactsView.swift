import SwiftUI
import SwiftUIRedux

struct ContactsView: ConnectedView {

  @EnvironmentObject
  private var store: Store<AppState>

  @State
  private var hideNavigationBar = false

  private var searchText: Binding<String> {
    Binding(
      get: { store.state.contactsState.searchText },
      set: {
        store.dispatch(action: ContactsActions.SetSearchText(searchText: $0)) }
    )
  }

  struct Props {
    let contacts: Loadable<[User]>
    let searchText: String
    let loadContacts: () -> Void
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      contacts: state.contactsState.contacts,
      searchText: state.contactsState.searchText,
      loadContacts: { dispatch(ContactsActions.LoadContacts()) }
    )
  }

  func body(props: Props) -> some View {
    NavigationView {
      ZStack {
        Background(.bg_info_200) // 解决搜索框弹出时，导航栏处背景颜色不一的问题

        VStack(spacing: 0) {
          SearchBar(
            searchText: searchText,
            onEditingChanged: {
              hideNavigationBar = true
            },
            onCancelButtonTapped: {
              hideNavigationBar = false
            }
          )

          ContactsList(
            contacts: props.contacts,
            searchText: props.searchText,
            loadContacts: props.loadContacts,
            header: {
              Section {
                ContactCategoriesList()
              }
            }
          )

          Spacer(minLength: 0)
        }
      }
      .background(Color.bg_info_200)
      .navigationTitle(Strings.tabbar_contacts())
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: Image("icons_outlined_add_friends"))
      .navigationBarBackgroundLightGray()
      .navigationBarHidden(hideNavigationBar)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

  init() {
    let tableView = UITableView.appearance()
    tableView.backgroundColor = UIColor(.bg_info_200)
    tableView.separatorStyle = .none
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
