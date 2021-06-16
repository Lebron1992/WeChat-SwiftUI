import SwiftUI

struct ContactsView: View {
  var body: some View {
    Text("ContactsView!")
      .navigationBarTitle(Strings.tabbar_contacts(), displayMode: .inline)
  }
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView()
  }
}
