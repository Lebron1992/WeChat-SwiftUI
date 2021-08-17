import SwiftUI

struct ActivityIndicator: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(.circular)
      .scaleEffect(1.8)
      .padding(40)
  }
}

struct ActivityIndicator_Previews: PreviewProvider {
  static var previews: some View {
    ActivityIndicator()
  }
}
