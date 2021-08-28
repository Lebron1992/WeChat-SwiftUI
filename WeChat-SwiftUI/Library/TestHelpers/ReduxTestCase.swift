import Foundation
import XCTest
@testable import WeChat_SwiftUI

protocol ReduxTestCase {
  func preparedAppState(with dialogs: [Dialog]) -> AppState
}

extension ReduxTestCase where Self: XCTestCase {
  func preparedAppState(with dialogs: [Dialog]) -> AppState {
    var appState: AppState = .preview
    appState.chatsState.dialogs = dialogs
    return appState
  }
}
