import Foundation

/// 全局堆栈，用于保存应用要访问的全局对象。
enum AppEnvironment {

  /// 最新的 Environment 对象。
  static var current: Environment! {
    return stack.last
  }

  private static var stack: [Environment] = {
    // 根据 info.plist 的配置决定应用环境
    let isStaging: Bool = {
      if let isStagingStr = Bundle.main.infoDictionary?["IS_STAGING"] as? String {
        return isStagingStr == "YES"
      }
      return false
    }()
    let environment: EnvironmentType = isStaging ? .staging : .production
    let service = Service(
      serverConfig: ServerConfig.config(for: environment),
      oauthToken: nil
    )
    let env = Environment(apiService: service)
    return [env]
  }()

  /// 获得 token 并希望用户登录时调用，替换当前的 apiService 和 currentUser。
  /// - Parameter envelope: 带有 token 和 user 的数据模型。
  static func login(_ envelope: AccessTokenEnvelope) {
    replaceCurrentEnvironment(
      apiService: self.current.apiService.login(OauthToken(token: envelope.accessToken)),
      currentUser: envelope.user
    )
  }

  /// 获得一个新用户并希望替换当前环境的用户时调用。
  /// - Parameter user: User 数据模型。
  static func updateCurrentUser(_ user: User) {
    replaceCurrentEnvironment(currentUser: user)
  }

  /// 替换当前环境的语言。
  /// - Parameter language: Language 数据模型。
  static func updateLanguage(_ language: Language) {
    replaceCurrentEnvironment(language: language)
  }

  /// 在希望停止用户会话时调用。
  static func logout() {
    replaceCurrentEnvironment(
      apiService: AppEnvironment.current.apiService.logout(),
      currentUser: nil
    )
  }

  /// 添加一个新的 Environment 对象到栈中。
  static func pushEnvironment(_ env: Environment) {
    saveEnvironment(
      environment: env,
      userDefaults: env.userDefaults
    )
    stack.append(env)
  }

  /// 移除并返回栈中的最后一个 Environment 对象。
  @discardableResult
  static func popEnvironment() -> Environment? {
    let last = self.stack.popLast()
    let next = self.current ?? Environment()
    self.saveEnvironment(
      environment: next,
      userDefaults: next.userDefaults
    )
    return last
  }

  /// 用一个新的 Environment 对象替换当前的 Environment 对象。
  static func replaceCurrentEnvironment(_ env: Environment) {
    self.pushEnvironment(env)
    self.stack.remove(at: self.stack.count - 2)
  }

  /// 更新当前 Environment 的一些全局变量。
  static func replaceCurrentEnvironment(
    apiService: ServiceType = AppEnvironment.current.apiService,
    currentUser: User? = AppEnvironment.current.currentUser,
    firestoreService: FirestoreServiceType = AppEnvironment.current.firestoreService,
    language: Language = AppEnvironment.current.language,
    userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults
  ) {
    replaceCurrentEnvironment(
      Environment(
        apiService: apiService,
        currentUser: currentUser,
        firestoreService: firestoreService,
        language: language,
        userDefaults: userDefaults
      )
    )
  }

  /// 更新当前 Environment 的一些全局变量。
  static func pushEnvironment(
    apiService: ServiceType = AppEnvironment.current.apiService,
    currentUser: User? = AppEnvironment.current.currentUser,
    firestoreService: FirestoreServiceType = AppEnvironment.current.firestoreService,
    language: Language = AppEnvironment.current.language,
    userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults
  ) {
    pushEnvironment(
      Environment(
        apiService: apiService,
        currentUser: currentUser,
        firestoreService: firestoreService,
        language: language,
        userDefaults: userDefaults
      )
    )
  }

  // MARK: - Save & Restore

  static let environmentStorageKey = "com.wechat.AppEnvironment.current"

  /// 从  userDefaults 保存的数据恢复 Environment 对象。
  static func fromStorage(userDefaults: KeyValueStoreType) -> Environment {
    let data = userDefaults.dictionary(forKey: .appEnvironment) ?? [:]

    var service = current.apiService
    var currentUser: User?

    if let oauthToken = data["apiService.oauthToken.token"] as? String {
      service = service.login(OauthToken(token: oauthToken))
    }

    if service.oauthToken != nil {
      currentUser = data["currentUser"].flatMap(tryDecode)
    }

    return Environment(
      apiService: service,
      currentUser: currentUser
    )
  }

  /// 把当前的 Environment 对象保存到 userDefaults。
  static func saveEnvironment(
    environment env: Environment = AppEnvironment.current,
    userDefaults: KeyValueStoreType
  ) {
    var data: [String: Any] = [:]

    data["apiService.oauthToken.token"] = env.apiService.oauthToken?.token
    data["currentUser"] = env.currentUser?.dictionaryRepresentation

    userDefaults.set(data, forKey: .appEnvironment)
  }
}

extension AppEnvironment {
  static var isUserLoggedIn: Bool {
    current.currentUser != nil
  }
}
