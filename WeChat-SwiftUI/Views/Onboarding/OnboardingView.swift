import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SwiftUIRedux

struct OnboardingView: View {

  @EnvironmentObject
  private var store: Store<AppState>

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

  var body: some View {
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
          Button(action: login) {
            Text(Strings.onboarding_login())
          }
        } else {
          Button(action: register) {
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
    .onChange(of: viewModel.registerStatus, perform: handleRegisterStatusChange(_:))
    .onChange(of: viewModel.signInStatus, perform: handleSignInStatusChange(_:))
    .onChange(of: viewModel.usernameUpdateStatus, perform: handleUsernameUpdateStatusChange(_:))
    .onChange(of: viewModel.userSelfUpdateStatus, perform: handleUserSelfUpdateStatusChange(_:))
  }
}

// MARK: - Helper Methods
private extension OnboardingView {
  func login() {
    guard allFieldsAreValid() else {
        setErrorMessage(Strings.onboarding_email_password_cannot_empty())
      return
    }
    viewModel.signIn(email: email, password: password)
  }

  func register() {
    guard allFieldsAreValid() else {
        setErrorMessage(Strings.onboarding_name_email_password_cannot_empty())
      return
    }
    viewModel.register(email: email, password: password)
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

  func handleRegisterStatusChange(_ status: ValueUpdateStatus<AuthDataResult>) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let result):
      setShowLoading(false)
      viewModel.updateUsername(authResult: result, username: name)
    case .failed(let error):
      setShowLoading(false)
      setErrorMessage(error.localizedDescription)
    }
  }

  func handleSignInStatusChange(_ status: ValueUpdateStatus<User>) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let user):
      setShowLoading(false)
      updateSignedInUser(user)
    case .failed(let error):
      setShowLoading(false)
      setErrorMessage(error.localizedDescription)
    }
  }

  func handleUsernameUpdateStatusChange(_ status: ValueUpdateStatus<User>) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let user):
      setShowLoading(false)
      viewModel.updateUserSelf(user)
    case .failed(let error):
      setShowLoading(false)
      setErrorMessage(error.localizedDescription)
    }
  }

  func handleUserSelfUpdateStatusChange(_ status: ValueUpdateStatus<User>) {
    switch status {
    case .idle:
      setShowLoading(false)
    case .updating:
      setShowLoading(true)
    case .finished(let user):
      setShowLoading(false)
      updateSignedInUser(user)
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
    OnboardingView()
  }
}
