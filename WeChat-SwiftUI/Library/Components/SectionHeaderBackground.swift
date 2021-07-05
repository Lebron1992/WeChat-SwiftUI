import SwiftUI

struct SectionHeaderBackground: View {
  let color: Color

  init(_ color: Color = .app_bg) {
    self.color = color
  }

  var body: some View {
    color
      .listRowInsets(.zero)
  }
}

struct SectionHeaderBackground_Previews: PreviewProvider {
  static var previews: some View {
    SectionHeaderBackground()
  }
}
