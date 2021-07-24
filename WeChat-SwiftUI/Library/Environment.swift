import Foundation

/// 应用想要访问的**所有**全局变量和单例的集合。
struct Environment {
  /// 用于从自己的后台获取数据的类型。
  let apiService: ServiceType

  /// 用于从 Firebase 的 Firestore Database 获取数据的类型，代替 apiService 用于模拟数据
  let firestoreService: FirestoreServiceType

  /// 当前已登录的用户。
  let currentUser: User?

  /// 用户的当前语言，用于确定要加载哪个本地化字符串包。
  let language: Language

  /// 用户默认的 key-value 存储，默认是 `UserDefaults.standard`。
  let userDefaults: KeyValueStoreType

  init(
    apiService: ServiceType = Service(),
    firestoreService: FirestoreServiceType = FirestoreService(),
    currentUser: User? = nil,
    language: Language = Language(languageStrings: Locale.preferredLanguages) ?? .zh,
    userDefaults: KeyValueStoreType = UserDefaults.standard
  ) {
    self.apiService = apiService
    self.firestoreService = firestoreService
    self.currentUser = currentUser
    self.language = language
    self.userDefaults = userDefaults
  }
}
