import Foundation
import SwiftUIRedux

enum RootActions {
  struct SetSelectedTab: Action {
    let tab: TabBarItem
  }
}
