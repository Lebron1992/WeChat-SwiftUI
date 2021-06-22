import SwiftUI

struct MeView: View {
  var body: some View {
    NavigationView {
      Text("MeView!")
        .navigationBarItems(trailing: Image("icons_filled_camera"))
        .navigationBarBackgroundWhite()
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct MeView_Previews: PreviewProvider {
  static var previews: some View {
    MeView()
  }
}
