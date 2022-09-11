import Foundation

/// 用于让 App Action 能自动实现 `Equatable` 协议
struct ErrorEnvelope: Error {
  let error: Error

  init(error: Error) {
    self.error = error
  }

  var localizedDescription: String {
    error.localizedDescription
  }
}

extension ErrorEnvelope: Equatable {
  static func == (lhs: ErrorEnvelope, rhs: ErrorEnvelope) -> Bool {
    let e1 = lhs.error as NSError
    let e2 = rhs.error as NSError
    return e1.code == e2.code && e1.localizedDescription == e2.localizedDescription
  }
}

extension Error {
  func toEnvelope() -> ErrorEnvelope {
    .init(error: self)
  }
}
