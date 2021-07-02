import SwiftUI

extension Image {
  func resizeToFill() -> some View {
    resizable()
      .aspectRatio(contentMode: .fill)
  }
}
