import SwiftUI
import SwiftUIRedux

struct ContactsView: View {
  var body: some View {
    NavigationView {
      ContactsList()
        .navigationTitle(Strings.tabbar_contacts())
        .navigationBarTitleDisplayMode(.inline)
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
