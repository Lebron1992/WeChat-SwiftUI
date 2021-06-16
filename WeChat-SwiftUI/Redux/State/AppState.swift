import Foundation
import SwiftUIRedux

struct AppState: ReduxState {
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        AppState()
    }
}
#endif
