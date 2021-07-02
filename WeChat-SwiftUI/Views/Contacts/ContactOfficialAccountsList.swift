import SwiftUI
import SwiftUIRedux

struct ContactOfficialAccountsList: ConnectedView {

  @State
  private var isSearching = false

  @State
  private var searchText = ""

  struct Props {
    let accounts: Loadable<[OfficialAccount]>
    let loadAccounts: () -> Void
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      accounts: state.contactsState.officialAccounts,
      loadAccounts: { dispatch(ContactsActions.LoadOfficialAccounts()) }
    )
  }

  func body(props: Props) -> some View {
    ZStack {
      Background(.app_bg) // 解决搜索框弹出时，导航栏处背景颜色不一的问题

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
          contacts: props.accounts,
          searchText: searchText,
          loadContacts: props.loadAccounts,
          header: { EmptyView() },
          selectionDestination: { contact in
            Text(contact.name)
          }
        )

        Spacer(minLength: 0)
      }
    }
    .background(Color.app_bg)
    .navigationTitle(Strings.contacts_offical_account())
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing: Image("icons_outlined_add2"))
    .navigationBarBackgroundLightGray()
    .navigationBarHidden(isSearching)
  }
}

struct ContactOfficialAccountsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactOfficialAccountsList()
  }
}
