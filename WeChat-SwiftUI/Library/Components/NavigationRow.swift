import SwiftUI

struct NavigationRow<Destination: View, Label: View>: View {

  let showRightArrow: Bool
  let destination: Destination
  let label: () -> Label

  init(
  showRightArrow: Bool = false,
  destination: Destination,
  @ViewBuilder label: @escaping () -> Label
  ) {
    self.showRightArrow = showRightArrow
    self.destination = destination
    self.label = label
  }

  var body: some View {
    ZStack(alignment: .leading) {
      NavigationLink(destination: destination) {
        EmptyView()
      }
      .opacity(showRightArrow ? 1 : 0)
      label()
    }
  }
}

struct NavigationRow_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        NavigationRow(destination: EmptyView()) {
          Text("Hello")
        }
        NavigationRow(showRightArrow: true, destination: EmptyView()) {
          Text("World")
        }
      }
    }
  }
}
