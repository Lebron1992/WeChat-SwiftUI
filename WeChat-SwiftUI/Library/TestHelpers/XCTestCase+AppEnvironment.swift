import XCTest
@testable import WeChat_SwiftUI

extension XCTestCase {
  /// 将 Environment 存入到堆栈上，执行 body，然后从堆栈中移除 Environment。
  func withEnvironment(_ env: Environment, body: () async -> Void) async {
    AppEnvironment.pushEnvironment(env)
    await body()
    AppEnvironment.popEnvironment()
  }

  func withEnvironment(_ env: Environment, body: () -> Void) {
    AppEnvironment.pushEnvironment(env)
    body()
    AppEnvironment.popEnvironment()
  }

  /// 将 Environment 存入到堆栈上，执行 body，然后从堆栈中移除 Environment。
  func withEnvironment(
    apiService: ServiceType = AppEnvironment.current.apiService,
    currentUser: User? = AppEnvironment.current.currentUser,
    firestoreService: FirestoreServiceType = AppEnvironment.current.firestoreService,
    language: Language = AppEnvironment.current.language,
    userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults,
    body: () async -> Void
  ) async {
    await withEnvironment(
      Environment(
        apiService: apiService,
        currentUser: currentUser,
        firestoreService: firestoreService,
        language: language,
        userDefaults: userDefaults
      ),
      body: body
    )
  }

  func withEnvironment(
    apiService: ServiceType = AppEnvironment.current.apiService,
    currentUser: User? = AppEnvironment.current.currentUser,
    firestoreService: FirestoreServiceType = AppEnvironment.current.firestoreService,
    language: Language = AppEnvironment.current.language,
    userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults,
    body: () -> Void
  ) {
    withEnvironment(
      Environment(
        apiService: apiService,
        currentUser: currentUser,
        firestoreService: firestoreService,
        language: language,
        userDefaults: userDefaults
      ),
      body: body
    )
  }
}

extension XCTestCase {
  /// 将 Environment 存入到堆栈上，执行 body，然后从堆栈中移除 Environment。
  func withEnvironmentAsync(_ env: Environment, body: () async -> Void) async {
    AppEnvironment.pushEnvironment(env)
    await body()
    AppEnvironment.popEnvironment()
  }

  /// 将 Environment 存入到堆栈上，执行 body，然后从堆栈中移除 Environment。
  func withEnvironmentAsync(
    apiService: ServiceType = AppEnvironment.current.apiService,
    currentUser: User? = AppEnvironment.current.currentUser,
    firestoreService: FirestoreServiceType = AppEnvironment.current.firestoreService,
    firebaseStorageService: FirebaseStorageServiceType = AppEnvironment.current.firebaseStorageService,
    language: Language = AppEnvironment.current.language,
    userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults,
    body: () async -> Void
  ) async {
    await withEnvironmentAsync(
      Environment(
        apiService: apiService,
        currentUser: currentUser,
        firestoreService: firestoreService,
        firebaseStorageService: firebaseStorageService,
        language: language,
        userDefaults: userDefaults
      ),
      body: body
    )
  }
}
