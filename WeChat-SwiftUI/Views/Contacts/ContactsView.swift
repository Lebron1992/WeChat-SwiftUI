import SwiftUI
import SwiftUIRedux

struct ContactsView: View {
  var body: some View {
    NavigationView {
      ContactsList()
        .navigationBarTitle(Strings.tabbar_contacts(), displayMode: .inline)
    }
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
