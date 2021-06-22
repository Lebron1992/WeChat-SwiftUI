import SwiftUI
import SwiftUIRedux

struct ContactsView: View {
  var body: some View {
    NavigationView {
      ContactsList()
        .navigationTitle(Strings.tabbar_contacts())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Image("icons_outlined_add_friends"))
        .navigationBarBackgroundLightGray()
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
