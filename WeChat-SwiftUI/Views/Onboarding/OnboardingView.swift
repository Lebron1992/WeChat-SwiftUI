import SwiftUI
import ComposableArchitecture
import FirebaseAuth
import FirebaseFirestore

struct OnboardingView: View {

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Spacer()

        Group {
          if mode == .register {
            TextField(Strings.onboarding_name(), text: $name)
          }
          TextField(Strings.onboarding_email(), text: $email)
          SecureField(Strings.onboarding_password(), text: $password)
        }
        .disableAutocorrection(true)
        .autocapitalization(.none)
        .padding()
        .border(Color.text_primary, width: 1)

        HStack {
          if mode == .login {
            Button {
              login(viewStore)
            } label: {
              Text(Strings.onboarding_login())
            }
          } else {
            Button {
              register(viewStore)
            } label: {
              Text(Strings.onboarding_register())
            }
          }
        }

        Spacer()

        Button {
          mode = (mode == .login) ? .register : .login
        } label: {
          let mode = mode == .login ? Strings.onboarding_register() : Strings.onboarding_login()
          Text(Strings.onboarding_switch_to(mode: mode))
        }
      }
      .padding()
      .background(.white)
      .resignKeyboardOnTap()
      .showLoading(showLoading)
      .onChange(of: viewModel.registerStatus) {
        handleRegisterStatusChange($0, viewStore: viewStore)
      }
      .onChange(of: viewModel.signInStatus) {
        handleSignInStatusChange($0, viewStore: viewStore)
      }
      .onChange(of: viewModel.usernameUpdateStatus) { status in
        Task { await handleUsernameUpdateStatusChange(status, viewStore: viewStore) }
      }
      .onChange(of: viewModel.userSelfUpdateStatus) {
        handleUserSelfUpdateStatusChange($0, viewStore: viewStore)
      }
    }
  }

  let store: Store<AppState, AppAction>

  @StateObject
  private var viewModel = OnboardingViewModel()

  @State
  var mode: OnboardingMode = .login

  @State
  var name = ""

  @State
  var email = ""

  @State
  var password = ""

  @State
  var showLoading = false
}

// MARK: - Helper Methods
private extension OnboardingView {
  func login(_ viewStore: ViewStore<AppState, AppAction>) {
    guard allFieldsAreValid() else {
      viewStore.send(.system(.setErrorMessage(Strings.onboarding_email_password_cannot_empty())))
      return
    }
    Task { await viewModel.signIn(email: email, password: password) }
  }

  func register(_ viewStore: ViewStore<AppState, AppAction>) {
    guard allFieldsAreValid() else {
      viewStore.send(.system(.setErrorMessage(Strings.onboarding_name_email_password_cannot_empty())))
      return
    }
    Task { await viewModel.register(email: email, password: password) }
  }

  func allFieldsAreValid() -> Bool {
    switch mode {
    case .login:
      if email.isEmpty || password.isEmpty {
        return false
      }
    case .register:
      if name.isEmpty || email.isEmpty || password.isEmpty {
        return false
      }
    }
    return true
  }

  func setShowLoading(_ show: Bool) {
    showLoading = show
  }

  func handleRegisterStatusChange(
    _ status: ValueUpdateStatus<AuthDataResult>,
    viewStore: ViewStore<AppState, AppAction>
  ) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let result):
      setShowLoading(false)
      Task { await viewModel.updateUsername(authResult: result, username: name) }
    case .failed(let error):
      setShowLoading(false)
      viewStore.send(.system(.setErrorMessage(error.localizedDescription)))
    }
  }

  func handleSignInStatusChange(_ status: ValueUpdateStatus<User>, viewStore: ViewStore<AppState, AppAction>) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let user):
      setShowLoading(false)
      viewStore.send(.auth(.setSignedInUser(user)))
    case .failed(let error):
      setShowLoading(false)
      viewStore.send(.system(.setErrorMessage(error.localizedDescription)))
    }
  }

  func handleUsernameUpdateStatusChange(
    _ status: ValueUpdateStatus<User>,
    viewStore: ViewStore<AppState, AppAction>
  ) async {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let user):
      setShowLoading(false)
      await viewModel.updateUserSelf(user)
    case .failed(let error):
      setShowLoading(false)
      viewStore.send(.system(.setErrorMessage(error.localizedDescription)))
    }
  }

  func handleUserSelfUpdateStatusChange(_ status: ValueUpdateStatus<User>, viewStore: ViewStore<AppState, AppAction>) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let user):
      setShowLoading(false)
      viewStore.send(.auth(.setSignedInUser(user)))
    case .failed:
      setShowLoading(false)
    }
  }
}

extension OnboardingView {
  enum OnboardingMode {
    case login
    case register
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(),
      reducer: appReducer
    )
    OnboardingView(store: store)
  }
}
