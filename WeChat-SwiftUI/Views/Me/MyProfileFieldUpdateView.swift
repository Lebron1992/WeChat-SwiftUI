import SwiftUI

private let maxTextCountOfWhatsUp = 30
private let rowInsets = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

struct MyProfileFieldUpdateView: View {

  let field: Field

  init(field: Field) {
    self.field = field

    switch field {
    case .name(let name):
      text = name
      gender = .unknown
    case .gender(let gen):
      text = ""
      gender = gen
    case .whatsUp(let whatsUp):
      text = whatsUp
      gender = .unknown
    default:
      text = ""
      gender = .unknown
    }
  }

  @State
  private var text: String

  @State
  private var gender: User.Gender

  var body: some View {
    NavigationView {
      List {
        switch field {
        case .name:    NameEditor()
        case .gender:  GenderEditor()
        case .whatsUp: WhatsUpEditor()
        case .region:  EmptyView()
        }
      }
      .listStyle(.plain)
      .background(.app_bg)
      .navigationBarItems(
        leading: Button(action: {}, label: { Text("取消") }),
        trailing: Button(action: {}, label: { Text("完成") })
      )
    }
  }
}

private extension MyProfileFieldUpdateView {
  func NameEditor() -> some View {
    HStack {
      TextField("", text: $text)
        .font(.system(size: 16))
        .foregroundColor(.text_primary)
      Spacer()
      Button(action: {
        text = ""
      }) {
        Image(systemName: "xmark.circle.fill")
          .foregroundColor(.secondary)
      }
      .buttonStyle(.plain)
    }
    .listRowBackground(Color.app_white)
    .listRowSeparator(.hidden)
    .listRowInsets(rowInsets)
  }

  func GenderEditor() -> some View {
    ForEach([User.Gender.male, User.Gender.female], id: \.self) { item in
      let isSelected = item == gender
      HStack {
        Text(item.description)
          .font(.system(size: 16))
          .foregroundColor(.text_primary)
        Spacer()
        Image(systemName: "checkmark")
          .foregroundColor(.highlighted)
          .opacity(isSelected ? 1 : 0)
      }
      .contentShape(Rectangle())
      .onTapGesture {
        gender = item
      }
    }
    .listRowBackground(Color.app_white)
    .listRowInsets(rowInsets)
  }

  func WhatsUpEditor() -> some View {
    ZStack(alignment: .bottomTrailing) {
      TextEditor(text: $text)
        .font(.system(size: 16))
        .foregroundColor(.text_primary)
        .onChange(of: text, perform: { newValue in
          if newValue.count > maxTextCountOfWhatsUp {
            let to = newValue.index(newValue.startIndex, offsetBy: maxTextCountOfWhatsUp)
            text = String(newValue[newValue.startIndex..<to])
          }
        })
        .background(.app_white)
        .frame(height: 50)
      Text("\(maxTextCountOfWhatsUp - text.count)")
        .font(.system(size: 15))
        .foregroundColor(.text_info_100)
    }
    .listRowBackground(Color.app_white)
    .listRowSeparator(.hidden)
    .listRowInsets(rowInsets)
  }
}

extension MyProfileFieldUpdateView {
  enum Field {
    case name(String)
    case gender(User.Gender)
    case region
    case whatsUp(String)
  }
}

struct MyProfileFieldUpdateView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MyProfileFieldUpdateView(field: .name("Lebron"))
      MyProfileFieldUpdateView(field: .gender(.male))
      MyProfileFieldUpdateView(field: .whatsUp("Hello, SwiftUI!"))
    }
  }
}
