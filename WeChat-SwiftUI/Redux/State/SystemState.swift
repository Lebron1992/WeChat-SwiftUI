import Foundation

struct SystemState {
  var showLoading: Bool
  var errorMessage: String?
}

extension SystemState: Equatable {
  static func == (lhs: SystemState, rhs: SystemState) -> Bool {
    lhs.showLoading == rhs.showLoading &&
    lhs.errorMessage == rhs.errorMessage
  }
}

#if DEBUG
extension SystemState {
  static var preview: SystemState {
    SystemState(
      showLoading: false,
      errorMessage: nil
    )
  }
}
#endif
