import Foundation

enum ValueUpdateStatus<V: Equatable>: Equatable {
  case idle
  case updating
  case finished(V)
  case failed(Error)

  var value: V? {
    switch self {
    case .finished(let v):
      return v
    default:
      return nil
    }
  }

  var error: Error? {
    switch self {
    case .failed(let e):
      return e
    default:
      return nil
    }
  }

  static func == (lhs: ValueUpdateStatus, rhs: ValueUpdateStatus) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.updating, .updating):
      return true
    case (.finished(let lv), .finished(let rv)):
      return lv == rv
    case (.failed(let le), .failed(let re)):
      return le.localizedDescription == re.localizedDescription
    default: return false
    }
  }
}
