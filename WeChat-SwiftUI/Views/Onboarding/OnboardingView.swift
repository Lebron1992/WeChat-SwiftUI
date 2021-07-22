import SwiftUI
import FirebaseAuth
import SwiftUIRedux

struct OnboardingView: View {

  @EnvironmentObject
  private var store: Store<AppState>

  @State
  var mode: OnboardingMode = .login

  @State
  var name: String = ""

  @State
  var email: String = ""

  @State
  var password: String = ""

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
    .resignKeyboardOnTapGesture()
  }

  private func login() {
    guard allFieldsAreValid() else {
      return
    }

    setShowLoading(true)

    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      setShowLoading(false)

      if let error = error {
        setErrorMessage(error.localizedDescription)

      } else if let result = result {

        let user = User(firUser: result.user)
        setSignedInUser(user)
      }
    }
  }

  private func register() {
    guard allFieldsAreValid() else {
      return
    }

    setShowLoading(true)

    Auth.auth().createUser(withEmail: email, password: password) { result, error in

      if let error = error {
        setErrorMessage(error.localizedDescription)
        setShowLoading(false)

      } else if let result = result {

        let request = result.user.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { _ in
          let user = User(firUser: result.user)
          setSignedInUser(user)
          setShowLoading(false)
        }
      }
    }
  }

  private func allFieldsAreValid() -> Bool {
    switch mode {
    case .login:
      if email.isEmpty || password.isEmpty {
        setErrorMessage(Strings.onboarding_email_password_cannot_empty())
        return false
      }
    case .register:
      if name.isEmpty || email.isEmpty || password.isEmpty {
        setErrorMessage(Strings.onboarding_name_email_password_cannot_empty())
        return false
      }
    }
    return true
  }
}

extension OnboardingView {
  enum OnboardingMode {
    case login
    case register
  }
}

// MARK: - Update Store
private extension OnboardingView {
  func setShowLoading(_ show: Bool) {
    store.dispatch(action: SystemActions.SetShowLoading(showLoading: show))
  }

  func setErrorMessage(_ message: String) {
    store.dispatch(action: SystemActions.SetErrorMessage(message: message))
  }

  func setSignedInUser(_ user: User) {
    AppEnvironment.updateCurrentUser(user)
    store.dispatch(action: AuthActions.SetSignedInUser(user: user))
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
