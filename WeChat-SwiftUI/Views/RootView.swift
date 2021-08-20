import SwiftUI
import SwiftUIRedux

/* TODO:
--- push ViewController 时，TabBar 不会隐藏，等待苹果的解决方案。（可选方案：可以把整个 TabView 包装在 NavigationView 内，此方案不方便进行导航栏按钮的控制。）
 */

struct RootView: View {

  @EnvironmentObject
  private var store: Store<AppState>

  var body: some View {
    TabView(selection: selectedTab) {
      ChatsView()
        .tabItem { tabItem(for: .chats) }
        .tag(TabBarItem.chats.rawValue)

      ContactsView()
        .tabItem { tabItem(for: .contacts) }
        .tag(TabBarItem.contacts.rawValue)

      DiscoverView()
        .tabItem { tabItem(for: .discover) }
        .tag(TabBarItem.discover.rawValue)

      MeView()
        .tabItem { tabItem(for: .me) }
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

  private func tabItem(for tab: TabBarItem) -> some View {
    VStack {
      tab.rawValue == selectedTab.wrappedValue ? tab.selectedImage : tab.defaultImage
      Text(tab.title)
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
