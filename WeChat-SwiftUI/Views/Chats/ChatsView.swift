import SwiftUI

struct ChatsView: View {
  var body: some View {
    NavigationView {
      DialogsList()
        .navigationTitle(Strings.tabbar_chats())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Image("icons_outlined_add"))
        .navigationBarBackgroundLightGray()
    }
    .navigationViewStyle(.stack)
  }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
