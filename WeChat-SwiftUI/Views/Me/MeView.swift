import SwiftUI

struct MeView: View {
  var body: some View {
    NavigationView {
      Text("MeView!")
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
