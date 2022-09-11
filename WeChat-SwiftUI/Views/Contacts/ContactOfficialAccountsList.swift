import SwiftUI

struct ContactOfficialAccountsList: View {

  var body: some View {
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
        contacts: accounts,
        searchText: searchText,
        loadContacts: loadAccounts,
        header: { EmptyView() },
        selectionDestination: { contact in
          Text(contact.name)
        }
      )

      Spacer(minLength: 0)
    }
    .background(.app_bg)
    .navigationTitle(Strings.contacts_offical_account())
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing: Image("icons_outlined_add2"))
    .navigationBarHidden(isSearching)
  }

  let accounts: Loadable<[OfficialAccount]>
  let loadAccounts: () -> Void

  @State
  private var isSearching = false

  @State
  private var searchText = ""
}

struct ContactOfficialAccountsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactOfficialAccountsList(
      accounts: .loaded([.template1, .template2]),
      loadAccounts: {}
    )
  }
}
