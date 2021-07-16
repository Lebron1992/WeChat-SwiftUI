import SwiftUI

/*
 TODO:
--- 如果点击 Placeholder，键盘不会弹出
 */

struct SearchBar: View {

  @Binding
  var searchText: String

  let onEditingChanged: () -> Void
  let onCancelButtonTapped: () -> Void

  @State
  private var showCancelButton: Bool = false

  var body: some View {
    withAnimation {
      HStack(spacing: 5) {
        HStack {
          ZStack(alignment: showCancelButton ? .leading : .center) {
            HStack {
              Spacer(minLength: showCancelButton ? 25 : 0)

              TextField("", text: $searchText, onEditingChanged: { _ in
                self.showCancelButton = true
                onEditingChanged()
              })
                .disableAutocorrection(true)
                .foregroundColor(.black)
                .textFieldStyle(DefaultTextFieldStyle())
                .frame(height: 30)

              Button(action: {
                self.searchText = ""
              }) {
                Image(systemName: "xmark.circle.fill")
                  .opacity(searchText.isEmpty ? 0 : 1)
              }
            }

            HStack {
              Image(systemName: "magnifyingglass")
              Text(Strings.general_search())
                .foregroundColor(.text_info_100)
                .opacity(searchText.isEmpty ? 1 : 0)
            }
            .padding(.leading, showCancelButton ? 5 : 0)
            .animation(searchText.isEmpty ? .default : .none, value: searchText.isEmpty)
          }
          .background(.app_white)
          .cornerRadius(4)
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.secondary)
        .background(.app_bg)

        if showCancelButton {
          Button(Strings.general_cancel()) {
            UIApplication.shared.endEditing(true)
            self.searchText = ""
            self.showCancelButton = false
            onCancelButtonTapped()
          }
          .foregroundColor(Color.link)
          .padding(.trailing, 5)
        }
      }
      .background(.app_bg)
    }
  }
}

struct SearchBar_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      SearchBar(
        searchText: Binding<String>(get: { "" }, set: { _ in }),
        onEditingChanged: {},
        onCancelButtonTapped: {}
      )
      .environment(\.colorScheme, .light)

      SearchBar(
        searchText: Binding<String>(get: { "" }, set: { _ in }),
        onEditingChanged: {},
        onCancelButtonTapped: {}
      )
      .environment(\.colorScheme, .dark)
    }
  }
}
