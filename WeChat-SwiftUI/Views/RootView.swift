import SwiftUI
import SwiftUIRedux

struct RootView: View {

  @EnvironmentObject
  private var store: Store<AppState>

  init() {
    // TODO: 有更好的方法？
    // 设置 tab bar 未选中颜色
    UITabBar.appearance().unselectedItemTintColor = .text_primary
  }

  var body: some View {
    TabView(selection: selectedTab) {
      ChatsView()
        .tabItem({ tabItemView(for: .chats) })
        .tag(TabBarItem.chats.rawValue)

      ContactsView()
        .tabItem({ tabItemView(for: .contacts) })
        .tag(TabBarItem.contacts.rawValue)

      DiscoverView()
        .tabItem({ tabItemView(for: .discover) })
        .tag(TabBarItem.discover.rawValue)

      MeView()
        .tabItem({ tabItemView(for: .me) })
        .tag(TabBarItem.me.rawValue)
    }
    .accentColor(.highlighted) // 设置 tab bar 选中颜色
  }

  private var selectedTab: Binding<Int> {
    Binding(
      get: { store.state.rootState.selectedTab.rawValue },
      set: {
        let tab = TabBarItem(rawValue: $0)!
        store.dispatch(action: RootActions.SetSelectedTab(tab: tab)) }
    )
  }
}

// MARK: - Helper Methods
extension RootView {
  private func tabItemView(for tab: TabBarItem) -> AnyView {
    AnyView(
      VStack {
        tab.rawValue == selectedTab.wrappedValue ? tab.selectedImage : tab.defaultImage
        Text(tab.title)
      }
    )
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
