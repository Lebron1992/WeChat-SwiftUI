import XCTest
@testable import WeChat_SwiftUI

final class AppEnvironmentTests: XCTestCase {
  private let preferredLanguage = Language(languageStrings: Locale.preferredLanguages)

  override func setUp() {
    super.setUp()
    // push a clean environment to avoid impacting logged in user
    AppEnvironment.pushEnvironment(Environment())
  }

  override func tearDown() {
    super.tearDown()
    // pop the clean environment pushed in setup
    AppEnvironment.popEnvironment()
  }

  func test_pushAndPopEnvironment() {
    let env1 = Environment()

    AppEnvironment.pushEnvironment(env1)
    XCTAssertTrue(env1.apiService == AppEnvironment.current.apiService)
    XCTAssertNil(env1.currentUser)
    XCTAssertEqual(env1.language, preferredLanguage)

    let env2 = Environment(
      apiService: Service(serverConfig: ServerConfig.production, oauthToken: OauthToken(token: "cafebeef")),
      currentUser: .template1,
      language: .en
    )
    AppEnvironment.pushEnvironment(env2)
    XCTAssertTrue(env2.apiService == AppEnvironment.current.apiService)
    XCTAssertEqual(env2.currentUser, .template1)
    XCTAssertEqual(env2.language, .en)

    AppEnvironment.popEnvironment()
    XCTAssertTrue(env1.apiService == AppEnvironment.current.apiService)
    XCTAssertNil(env1.currentUser)
    XCTAssertEqual(env1.language, preferredLanguage)

    AppEnvironment.popEnvironment()
  }

  func test_replaceCurrentEnvironment() {
    AppEnvironment.pushEnvironment(language: .zh)
    XCTAssertEqual(AppEnvironment.current.language, .zh)

    AppEnvironment.replaceCurrentEnvironment(language: .en)
    XCTAssertEqual(AppEnvironment.current.language, .en)

    let apiService = Service(
      serverConfig: ServerConfig.production,
      oauthToken: OauthToken(token: "cafebeef")
    )
    AppEnvironment.replaceCurrentEnvironment(apiService: apiService)
    XCTAssertTrue(AppEnvironment.current.apiService == apiService)

    AppEnvironment.replaceCurrentEnvironment(currentUser: .template1)
    XCTAssertEqual(AppEnvironment.current.currentUser, .template1)

    AppEnvironment.popEnvironment()
  }

  func test_persistenceKey() {
    XCTAssertEqual(
      "com.WeChat-SwiftUI.appEnvironment", KeyValueStoreKey.appEnvironment.key,
      "测试失败意味着用户将会被登出。"
    )
  }

  func test_userSession() {
    AppEnvironment.pushEnvironment(userDefaults: MockKeyValueStore())

    XCTAssertNil(AppEnvironment.current.apiService.oauthToken)
    XCTAssertNil(AppEnvironment.current.currentUser)

    AppEnvironment.login(AccessTokenEnvelope(accessToken: "deadbeef", user: .template1))

    XCTAssertEqual("deadbeef", AppEnvironment.current.apiService.oauthToken?.token)
    XCTAssertEqual(User.template1, AppEnvironment.current.currentUser)

    AppEnvironment.updateCurrentUser(User.template1)

    XCTAssertEqual("deadbeef", AppEnvironment.current.apiService.oauthToken?.token)
    XCTAssertEqual(User.template1, AppEnvironment.current.currentUser)

    AppEnvironment.logout()

    XCTAssertNil(AppEnvironment.current.apiService.oauthToken)
    XCTAssertNil(AppEnvironment.current.currentUser)

    AppEnvironment.popEnvironment()
  }

  func test_fromStorage_WithNothingStored() {
    let userDefaults = MockKeyValueStore()
    let env = AppEnvironment.fromStorage(userDefaults: userDefaults)

    XCTAssertNil(env.apiService.oauthToken?.token)
    XCTAssertNil(env.currentUser)
  }

  func test_fromStorage_WithFullDataStored() {
    let userDefaults = MockKeyValueStore()
    let user = User.template1

    userDefaults.set(
      [
        "apiService.oauthToken.token": "deadbeef",
        "currentUser": user.dictionaryRepresentation as Any
      ],
      forKey: .appEnvironment
    )

    let env = AppEnvironment.fromStorage(userDefaults: userDefaults)

    XCTAssertEqual("deadbeef", env.apiService.oauthToken?.token)
    XCTAssertEqual(user, env.currentUser)

    let differentEnv = AppEnvironment.fromStorage(userDefaults: MockKeyValueStore())
    XCTAssertNil(differentEnv.apiService.oauthToken?.token)
    XCTAssertNil(differentEnv.currentUser)
  }

  func testSaveEnvironment() {
    let apiService = Service(
      serverConfig: ServerConfig.production,
      oauthToken: OauthToken(token: "deadbeef")
    )
    let currentUser = User.template1
    let userDefaults = MockKeyValueStore()

    AppEnvironment.saveEnvironment(
      environment: Environment(apiService: apiService, currentUser: currentUser),
      userDefaults: userDefaults
    )

    let result = userDefaults.dictionary(forKey: .appEnvironment)!

    XCTAssertEqual("deadbeef", result["apiService.oauthToken.token"] as? String)
    XCTAssertEqual(currentUser?.id, (result["currentUser"] as? [String: Any])?["id"] as? String)
  }

  func test_restoreFromEnvironment() {
    let apiService = Service(
      serverConfig: ServerConfig.production,
      oauthToken: OauthToken(token: "deadbeef")
    )

    let currentUser = User.template1
    let userDefaults = MockKeyValueStore()

    AppEnvironment.saveEnvironment(
      environment: Environment(apiService: apiService, currentUser: currentUser),
      userDefaults: userDefaults
    )

    let env = AppEnvironment.fromStorage(userDefaults: userDefaults)

    XCTAssertEqual("deadbeef", env.apiService.oauthToken?.token)
    XCTAssertEqual(
      ServerConfig.production.apiBaseUrl.absoluteString,
      env.apiService.serverConfig.apiBaseUrl.absoluteString
    )
    XCTAssertEqual(.production, env.apiService.serverConfig.environment)
    XCTAssertEqual(currentUser, env.currentUser)
  }

  func test_pushPopSave() {
    AppEnvironment.pushEnvironment(userDefaults: MockKeyValueStore())
    AppEnvironment.pushEnvironment(currentUser: .template1)

    var currentUserId = AppEnvironment.current.userDefaults
      .dictionary(forKey: .appEnvironment)
      .flatMap { $0["currentUser"] as? [String: Any] }
      .flatMap { $0["id"] as? String }
    XCTAssertEqual(User.template1.id, currentUserId, "当前用户已保存。")

    AppEnvironment.popEnvironment()

    currentUserId = AppEnvironment.current.userDefaults
      .dictionary(forKey: .appEnvironment)
      .flatMap { $0["currentUser"] as? [String: Any] }
      .flatMap { $0["id"] as? String }
    XCTAssertEqual(nil, currentUserId, "当前用户被移除。")

    AppEnvironment.popEnvironment()
  }

  func test_updateLanguage() {
    AppEnvironment.pushEnvironment()

    XCTAssertEqual(AppEnvironment.current.language, preferredLanguage)

    AppEnvironment.updateLanguage(.en)
    XCTAssertEqual(AppEnvironment.current.language, .en)

    AppEnvironment.popEnvironment()
  }
}
