import SwiftUI
import SwiftUIRedux

/* TODO:
--- 暗黑模式时，TextEditor 的背景颜色不对
 */

private let maxTextCountOfWhatsUp = 30
private let rowInsets = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

struct MyProfileFieldUpdateView: View {

  let field: Field

  @EnvironmentObject
  private var store: Store<AppState>

  @SwiftUI.Environment(\.dismiss)
  private var dismiss

  @State
  private var text = ""

  @State
  private var gender = User.Gender.unknown

  @State
  private var showLoading = false

  private let cancelBag = CancelBag()

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
      .navigationTitle(field.navigationBarTitle)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(leading: CancelButton(), trailing: DoneButton())
      .showLoading(showLoading)
    }
    .onAppear(perform: setDefaultValues)
  }
}

// MARK: - Helper Methods
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
      .contentShape(Rectangle()) // make onTapGesture can be triggered
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

  func CancelButton() -> some View {
    Button(action: { dismiss() }, label: {
      Text(Strings.general_cancel())
        .foregroundColor(.text_primary)
    })
  }

  func DoneButton() -> some View {
    Button(action: doneButtonTapped, label: {
      Text(Strings.general_done())
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(isValueChanged ? .white : .text_info_80)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(isValueChanged ? .highlighted : .bg_info_200)
        .cornerRadius(4)
    })
      .disabled(!isValueChanged)
  }

  func doneButtonTapped() {
    guard isValueChanged else {
      return
    }

    setShowLoading(true)

    AppEnvironment.current.firestoreService
      .overrideUser(newUser)
      .sinkForUI(receiveCompletion: { completion in

        setShowLoading(false)

        switch completion {
        case .finished:
          updateSignedInUser(newUser)
          dismiss()
        case let .failure(error):
          setErrorMessage("Error saving user: \(error.localizedDescription)")
        }
      })
      .store(in: cancelBag)
  }

  func setDefaultValues() {
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

  var isValueChanged: Bool {
    switch field {
    case .name(let name):
      return name != text
    case .gender(let gender):
      return gender != self.gender
    case .region:
      return false
    case .whatsUp(let whatsUp):
      return whatsUp != text
    }
  }

  var newUser: User {
    let currentUser = AppEnvironment.current.currentUser!

    guard isValueChanged else {
      return currentUser
    }

    switch field {
    case .name:
      return currentUser.setName(text)
    case .gender:
      return currentUser.setGender(gender)
    case .region:
      return currentUser
    case .whatsUp:
      return currentUser.setWhatsUp(text)
    }
  }

  func updateSignedInUser(_ user: User) {
    AppEnvironment.updateCurrentUser(user)
    store.dispatch(action: AuthActions.SetSignedInUser(user: user))
  }

  func setErrorMessage(_ message: String) {
    store.dispatch(action: SystemActions.SetErrorMessage(message: message))
  }

  func setShowLoading(_ show: Bool) {
    showLoading = show
  }
}

// MARK: - Field
extension MyProfileFieldUpdateView {
  enum Field {
    case name(String)
    case gender(User.Gender)
    case region
    case whatsUp(String)

    var navigationBarTitle: String {
      let name: String
      switch self {
      case .name:
        name = Strings.general_name()
      case .gender:
        name = Strings.general_gender()
      case .region:
        name = Strings.general_region()
      case .whatsUp:
        name = Strings.general_whats_up()
      }
      return "\(Strings.general_set()) \(name)"
    }
  }
}

struct MyProfileFieldUpdateView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MyProfileFieldUpdateView(field: .name("Lebron"))
      MyProfileFieldUpdateView(field: .gender(.male))
      MyProfileFieldUpdateView(field: .whatsUp("Hello, SwiftUI!"))
    }
    Group {
      MyProfileFieldUpdateView(field: .name("Lebron"))
      MyProfileFieldUpdateView(field: .gender(.male))
      MyProfileFieldUpdateView(field: .whatsUp("Hello, SwiftUI!"))
    }
    .colorScheme(.dark)
  }
}
