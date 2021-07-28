import SwiftUI

struct DiscoverView: View {
  var body: some View {
    NavigationView {
      DiscoverList()
        .navigationTitle(Strings.tabbar_discover())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackgroundLightGray()
    }
    .navigationViewStyle(.stack)
  }
}

struct DiscoverView_Previews: PreviewProvider {
  static var previews: some View {
    DiscoverView()
  }
}
