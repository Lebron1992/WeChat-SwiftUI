import SwiftUI

struct DialogsList: View {
  var body: some View {
    List {
      ForEach([Dialog.template1]) { dialog in
        ZStack(alignment: .leading) {
          NavigationLink(destination: DialogView()) {
            EmptyView()
          }
          .opacity(0)
          DialogRow(dialog: dialog)
        }
      }
      .listRowInsets(.zero)
    }
    .background(.app_bg)
    .listStyle(.plain)
  }
}

struct DialogsList_Previews: PreviewProvider {
  static var previews: some View {
    DialogsList()
  }
}
