import SwiftUI
import FirebaseAuth
import FirebaseFirestore
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

  private let cancelBag = CancelBag()

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
        setErrorMessage(Strings.onboarding_email_password_cannot_empty())
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
        setErrorMessage(Strings.onboarding_name_email_password_cannot_empty())
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

          // 注册成功，把用户保存到数据库中
          AppEnvironment.current.firestoreService
            .overrideUser(user)
            .sinkForUI(receiveCompletion: { completion in
              setSignedInUser(user)
              setShowLoading(false)
              // 未考虑错误的情况：因为实际情况中只有把用户保存到数据库中才算注册成功；
              // 这里使用 Firebase 注册，注册成功之后才把用户保存到数据库中，在保存出错的情况下，不方便把已注册的用户删除
              switch completion {
              case let .failure(error):
                print("Error saving user: \(error.localizedDescription)")
              default:
                break
              }
            })
            .store(in: cancelBag)
        }
      }
    }
  }

  private func allFieldsAreValid() -> Bool {
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
    // token is unnecessary for firestoreService, but we need to set it to make AppEnvironment works
    let token = "hello-world"
    let tokenEnvelope = AccessTokenEnvelope(accessToken: token, user: user)
    AppEnvironment.login(tokenEnvelope)
    store.dispatch(action: AuthActions.SetSignedInUser(user: user))
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
