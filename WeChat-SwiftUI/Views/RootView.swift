import SwiftUI
import ComposableArchitecture

/* TODO:
--- push ViewController 时，TabBar 不会隐藏，等待苹果的解决方案。（可选方案：可以把整个 TabView 包装在 NavigationView 内，此方案不方便进行导航栏按钮的控制。）
 */

struct RootView: View {

  var body: some View {
    WithViewStore(store) { viewStore in
      let selection = Binding(
        get: { viewStore.rootState.selectedTab.rawValue },
        set: {
          let tab = TabBarItem(rawValue: $0)!
          viewStore.send(.root(.setSelectedTab(tab)))
        }
      )
      TabView(selection: selection) {
        ChatsView(store: store)
          .tabItem { tabItem(for: .chats, isSelected: TabBarItem.chats == viewStore.rootState.selectedTab) }
          .tag(TabBarItem.chats.rawValue)

        ContactsView(store: store)
          .tabItem { tabItem(for: .contacts, isSelected: TabBarItem.contacts == viewStore.rootState.selectedTab) }
          .tag(TabBarItem.contacts.rawValue)

        DiscoverView(store: store.actionless.scope(state: \.discoverState))
          .tabItem { tabItem(for: .discover, isSelected: TabBarItem.discover == viewStore.rootState.selectedTab) }
          .tag(TabBarItem.discover.rawValue)

        MeView(store: store)
          .tabItem { tabItem(for: .me, isSelected: TabBarItem.me == viewStore.rootState.selectedTab) }
          .tag(TabBarItem.me.rawValue)
      }
      .accentColor(.highlighted) // 设置 tab bar 选中颜色
    }
  }

  let store: Store<AppState, AppAction>

  private func tabItem(for tab: TabBarItem, isSelected: Bool) -> some View {
    VStack {
      isSelected ? tab.selectedImage : tab.defaultImage
      Text(tab.title)
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(
        authState: .init(signedInUser: .template1),
        chatsState: .init(dialogs: [.template1, .template2], dialogMessages: []),
        contactsState: .init(
          categories: ContactCategory.allCases,
          contacts: .loaded([.template1, .template2]),
          officialAccounts: .loaded([.template1, .template2])
        )
      ),
      reducer: appReducer,
      environment: AppEnvironment.current
    )
    RootView(store: store)
  }
}
