import SwiftUI

struct ChatsView: View {
  var body: some View {
    NavigationView {
      Text("ChatsView!")
        .navigationBarTitle(Strings.tabbar_chats(), displayMode: .inline)
    }
  }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
