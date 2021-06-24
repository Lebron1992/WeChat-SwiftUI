import SwiftUI
import SwiftUIRedux

struct ContactsView: View {

  @EnvironmentObject
  private var store: Store<AppState>

  private var searchText: Binding<String> {
    Binding(
      get: { store.state.contactsState.searchText },
      set: {
        store.dispatch(action: ContactsActions.SetSearchText(searchText: $0)) }
    )
  }

  @State
  private var hideNavigationBar = false

  var body: some View {
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
          ContactsList()
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
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
