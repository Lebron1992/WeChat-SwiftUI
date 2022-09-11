import SwiftUI

struct NavigationRow<Destination: View, Label: View>: View {

  let content: AnyView

  init(
    showRightArrow: Bool = false,
    destination: Destination,
    @ViewBuilder label: @escaping () -> Label
  ) {
    content = ZStack(alignment: .leading) {
      NavigationLink(destination: destination) {
        EmptyView()
      }
      .opacity(showRightArrow ? 1 : 0)
      label()
    }
    .asAnyView()
  }

  init<V>(
    tag: V,
    selection: Binding<V?>,
    showRightArrow: Bool = false,
    destination: () -> Destination,
    label: () -> Label
  ) where V: Hashable {
    content = ZStack(alignment: .leading) {
      NavigationLink(
        tag: tag,
        selection: selection,
        destination: destination
      ) {
        EmptyView()
      }
      .opacity(showRightArrow ? 1 : 0)
      label()
    }
    .asAnyView()
  }

  var body: some View {
    content
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
