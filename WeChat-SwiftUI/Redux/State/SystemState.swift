import Foundation

struct SystemState: Equatable {
  var errorMessage: String?
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
