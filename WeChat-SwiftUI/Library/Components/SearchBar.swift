import SwiftUI

struct SearchBar: View {

  @Binding
  var searchText: String

  let onEditingChanged: () -> Void
  let onCancelButtonTapped: () -> Void

  @State
  private var showCancelButton: Bool = false

  @FocusState
  var isTextFieldFocused: Bool

  var body: some View {
    HStack {
      ZStack(alignment: showCancelButton ? .leading : .center) {
        HStack {
          Spacer(minLength: showCancelButton ? 24 : 0)
          textField
          clearButton
        }
        .padding(.horizontal, 4)

        HStack {
          Image(systemName: "magnifyingglass")
          placeholder
        }
        .padding(.leading, showCancelButton ? 6 : 0)
        .onTapGesture {
          isTextFieldFocused = true
        }
      }
      .background(.app_white)
      .cornerRadius(4)

      if showCancelButton {
        cancelButton
      }
    }
    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
    .foregroundColor(.secondary)
    .background(.app_bg)
  }

  private var textField: some View {
    TextField("", text: $searchText, onEditingChanged: { _ in
      withAnimation {
        showCancelButton = true
      }
      onEditingChanged()
    })
      .disableAutocorrection(true)
      .foregroundColor(.black)
      .textFieldStyle(DefaultTextFieldStyle())
      .focused($isTextFieldFocused)
      .frame(height: 30)
  }

  private var placeholder: some View {
    Text(Strings.general_search())
      .foregroundColor(.text_info_100)
      .opacity(searchText.isEmpty ? 1 : 0)
  }

  private var clearButton: some View {
    Button {
      searchText = ""
    } label: {
      Image(systemName: "xmark.circle.fill")
        .opacity(searchText.isEmpty ? 0 : 1)
    }
  }

  private var cancelButton: some View {
    Button(Strings.general_cancel()) {
      UIApplication.shared.endEditing(true)
      withAnimation {
        searchText = ""
        showCancelButton = false
      }
      onCancelButtonTapped()
    }
    .foregroundColor(Color.link)
    .padding(.trailing, 4)
  }
}

struct SearchBar_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      SearchBar(
        searchText: .constant(""),
        onEditingChanged: { },
        onCancelButtonTapped: { }
      )
      .environment(\.colorScheme, .light)

      SearchBar(
        searchText: .constant(""),
        onEditingChanged: { },
        onCancelButtonTapped: { }
      )
      .environment(\.colorScheme, .dark)
    }
  }
}
