import Foundation
import XCTest
@testable import WeChat_SwiftUI

protocol AppStateDataSource {
  func preparedAppState(dialogs: [Dialog], dialogMessages: Set<DialogMessages>) -> AppState
}

extension AppStateDataSource where Self: XCTestCase {
  func preparedAppState(dialogs: [Dialog], dialogMessages: Set<DialogMessages>) -> AppState {
    var appState: AppState = .preview
    appState.chatsState.dialogs = dialogs
    appState.chatsState.dialogMessages = dialogMessages
    return appState
  }
}
