import SwiftUI

struct Background: View {
  let color: Color

  init(_ color: Color) {
    self.color = color
  }

  var body: some View {
    color
      .ignoresSafeArea()
  }
}

struct Background_Previews: PreviewProvider {
  static var previews: some View {
    Background(.red)
  }
}
