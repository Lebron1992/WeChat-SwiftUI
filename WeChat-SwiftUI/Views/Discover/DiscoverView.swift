import SwiftUI

struct DiscoverView: View {
  var body: some View {
    NavigationView {
      Text("DiscoverView!")
        .navigationBarTitle(Strings.tabbar_discover(), displayMode: .inline)
    }
  }
}

struct DiscoverView_Previews: PreviewProvider {
  static var previews: some View {
    DiscoverView()
  }
}
