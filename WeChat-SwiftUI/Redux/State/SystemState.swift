import Foundation

struct SystemState {
  var errorMessage: String?
}

extension SystemState: Equatable {
  static func == (lhs: SystemState, rhs: SystemState) -> Bool {
    lhs.errorMessage == rhs.errorMessage
  }
}

#if DEBUG
extension SystemState {
  static var preview: SystemState {
    SystemState(
      errorMessage: nil
    )
  }
}
#endif
