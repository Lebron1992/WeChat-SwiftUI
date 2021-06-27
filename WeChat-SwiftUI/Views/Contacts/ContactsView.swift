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
      ZStack {
        Background(.bg_info_200) // 解决搜索框弹出时，导航栏处背景颜色不一的问题

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
            selectionDestination: { Text($0.name) }
          )

          Spacer(minLength: 0)
        }
      }
      .background(Color.bg_info_200)
      .navigationTitle(Strings.tabbar_contacts())
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: Image("icons_outlined_add_friends"))
      .navigationBarBackgroundLightGray()
      .navigationBarHidden(isSearching)
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
