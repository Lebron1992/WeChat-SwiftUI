import Foundation

/// 应用想要访问的**所有**全局变量和单例的集合。
struct Environment {
  /// 用于从自己的后台获取数据的类型。
  let apiService: ServiceType

  /// 代替 apiService 用于模拟真实开发，用 Firebase 处理用户系统
  let authService: FirebaseAuthServiceType

  /// 当前已登录的用户。
  let currentUser: User?

  /// 代替 apiService 用于模拟真实开发，用于从 Firebase 的 Firestore Database 获取数据的类型。
  let firestoreService: FirestoreServiceType

  /// 用于上传数据到 Firebase Storage
  let firebaseStorageService: FirebaseStorageServiceType

  /// 用户的当前语言，用于确定要加载哪个本地化字符串包。
  let language: Language

  /// 用户默认的 key-value 存储，默认是 `UserDefaults.standard`。
  let userDefaults: KeyValueStoreType

  init(
    apiService: ServiceType = Service(),
    authService: FirebaseAuthServiceType =  FirebaseAuthService(),
    currentUser: User? = nil,
    firestoreService: FirestoreServiceType = FirestoreService(),
    firebaseStorageService: FirebaseStorageServiceType = FirebaseStorageService(),
    language: Language = Language(languageStrings: Locale.preferredLanguages) ?? .zh,
    userDefaults: KeyValueStoreType = UserDefaults.standard
  ) {
    self.apiService = apiService
    self.authService = authService
    self.firestoreService = firestoreService
    self.firebaseStorageService = firebaseStorageService
    self.currentUser = currentUser
    self.language = language
    self.userDefaults = userDefaults
  }
}
