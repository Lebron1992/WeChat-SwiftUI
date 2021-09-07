import SwiftUI

struct MediaLoadingProgressView: View {

  let progress: Float
  let lineWidth: CGFloat
  let tintColor: Color

  init(progress: Float, lineWidth: CGFloat = 4, tintColor: Color = .white) {
    self.progress = progress
    self.lineWidth = lineWidth
    self.tintColor = tintColor
  }

  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: lineWidth)
        .foregroundColor(tintColor)
        .opacity(0.3)

      Circle()
        .trim(from: 0, to: CGFloat(min(progress, 1)))
        .stroke(style: StrokeStyle(
          lineWidth: lineWidth,
          lineCap: .round,
          lineJoin: .round
        ))
        .foregroundColor(tintColor)
        .rotationEffect(.init(degrees: -90))
    }
  }
}

struct MediaLoadingProgressView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MediaLoadingProgressView(progress: 0.5)
      MediaLoadingProgressView(progress: 0)
    }
      .foregroundColor(.white)
      .frame(width: 40, height: 40)
      .padding()
      .background(.black)
  }
}
