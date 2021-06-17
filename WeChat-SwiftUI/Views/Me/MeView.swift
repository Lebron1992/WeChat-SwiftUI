import SwiftUI

struct MeView: View {
  var body: some View {
    NavigationView {
      Text("MeView!")
        .navigationBarHidden(true)
    }
  }
}

struct MeView_Previews: PreviewProvider {
  static var previews: some View {
    MeView()
  }
}
