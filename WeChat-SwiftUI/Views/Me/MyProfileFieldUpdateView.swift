import SwiftUI
import ComposableArchitecture

/* TODO:
--- 暗黑模式时，TextEditor 的背景颜色不对
 */

struct MyProfileFieldUpdateView: View {

  var body: some View {
    WithViewStore(store.wrappedValue) { viewStore in
      NavigationView {
        List {
          switch field {
          case .name:    nameEditor
          case .gender:  genderEditor
          case .whatsUp: whatsUpEditor
          case .region:  EmptyView()
          }
        }
        .listStyle(.plain)
        .background(.app_bg)
        .navigationTitle(field.navigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: cancelButton, trailing: doneButton)
        .showLoading(showLoading)
        .onChange(of: viewModel.userSelfUpdateStatus) {
          handleUserSelfUpdateStatusChange($0, viewStore: viewStore)
        }
      }
      .onAppear(perform: setDefaultValues)
    }
  }

  let field: Field

  @EnvironmentObject
  private var store: StoreObservableObject<Void, AppAction>

  @SwiftUI.Environment(\.dismiss)
  private var dismiss

  @State
  private var text = ""

  @State
  private var gender = User.Gender.unknown

  @State
  private var showLoading = false

  @StateObject
  private var viewModel = UserSelfUpdateViewModel()
}

// MARK: - Views
private extension MyProfileFieldUpdateView {

  var nameEditor: some View {
    HStack {
      TextField("", text: $text)
        .font(.system(size: Constant.fieldFontSize))
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
    .listRowInsets(Constant.rowInsets)
  }

  var genderEditor: some View {
    ForEach([User.Gender.male, User.Gender.female], id: \.self) { item in
      let isSelected = item == gender
      HStack {
        Text(item.description)
          .font(.system(size: Constant.fieldFontSize))
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
    .listRowInsets(Constant.rowInsets)
  }

  var whatsUpEditor: some View {
    ZStack(alignment: .bottomTrailing) {
      TextEditor(text: $text)
        .font(.system(size: Constant.fieldFontSize))
        .foregroundColor(.text_primary)
        .background(.app_white)
        .frame(height: Constant.whatsUpEditorHeight)
        .onChange(of: text, perform: handleWhatsUpEditorTextChange(_:))

      Text("\(Constant.maxTextCountOfWhatsUp - text.count)")
        .font(.system(size: Constant.whatsUpEditorRemainingTextCountFontSize))
        .foregroundColor(.text_info_100)
    }
    .listRowBackground(Color.app_white)
    .listRowSeparator(.hidden)
    .listRowInsets(Constant.rowInsets)
  }

  var cancelButton: some View {
    Button {
      Task { await viewModel.cancelUpdateUserSelf() }
      dismiss()
    } label: {
      Text(Strings.general_cancel())
        .foregroundColor(.text_primary)
        .font(.system(size: Constant.actionButtonFontSize, weight: .medium))
    }
  }

  var doneButton: some View {
    Button {
      guard isValueChanged else { return }
      Task { await viewModel.updateUserSelf(newUser) }
    } label: {
      Text(Strings.general_done())
        .font(.system(size: Constant.actionButtonFontSize, weight: .medium))
        .foregroundColor(isValueChanged ? .white : .text_info_80)
        .padding(Constant.doneButtonPadding)
        .background(isValueChanged ? .highlighted : .bg_info_200)
        .cornerRadius(Constant.doneButtonCornerRadius)
    }
    .disabled(!isValueChanged)
  }
}

// MARK: - Helper Methods
private extension MyProfileFieldUpdateView {

  func handleUserSelfUpdateStatusChange(_ status: ValueUpdateStatus<User>, viewStore: ViewStore<Void, AppAction>) {
    switch status {
    case .updating:
      showLoading = true

    case .finished(let user):
      viewStore.send(.auth(.setSignedInUser(user)))
      showLoading = false
      dismiss()

    case .failed(let error):
      viewStore.send(.system(.setErrorMessage(error.localizedDescription)))
      showLoading = false
    default:
      showLoading = false
    }
  }

  func handleWhatsUpEditorTextChange(_ newText: String) {
    if newText.count > Constant.maxTextCountOfWhatsUp {
      let to = newText.index(newText.startIndex, offsetBy: Constant.maxTextCountOfWhatsUp)
      text = String(newText[newText.startIndex..<to])
    }
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
}

// MARK: - Getters
extension MyProfileFieldUpdateView {
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
}

private extension MyProfileFieldUpdateView {
  enum Constant {
    static let fieldFontSize: CGFloat = 16
    static let actionButtonFontSize: CGFloat = 16
    static let maxTextCountOfWhatsUp = 30
    static let whatsUpEditorHeight: CGFloat = 50
    static let whatsUpEditorRemainingTextCountFontSize: CGFloat = 15
    static let doneButtonPadding: EdgeInsets = .init(top: 6, leading: 10, bottom: 6, trailing: 10)
    static let doneButtonCornerRadius: CGFloat = 4
    static let rowInsets = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
  }
}

struct MyProfileFieldUpdateView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(),
      reducer: appReducer
    )
      .stateless
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
    .environmentObject(StoreObservableObject(store: store))
  }
}
