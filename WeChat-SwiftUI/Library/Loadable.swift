import SwiftUI

/// 表示通过请求才能得到的数据模型的几种状态，用户可以根据不同的状态来更新 UI
enum Loadable<T> {

  case notRequested
  case isLoading(last: T?)
  case loaded(T)
  case failed(Error)

  var value: T? {
    switch self {
    case let .loaded(value):
      return value
    case let .isLoading(last):
      return last
    default:
      return nil
    }
  }

  var error: Error? {
    switch self {
    case let .failed(error):
      return error
    default:
      return nil
    }
  }
}

extension Loadable {

  func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
    do {
      switch self {
      case .notRequested:
        return .notRequested
      case let .failed(error):
        return .failed(error)
      case let .isLoading(value):
        return .isLoading(last: try value.map { try transform($0) })
      case let .loaded(value):
        return .loaded(try transform(value))
      }
    } catch {
      return .failed(error)
    }
  }
}

extension Loadable: Equatable where T: Equatable {
  static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
    switch (lhs, rhs) {
    case (.notRequested, .notRequested):
      return true
    case let (.isLoading(lhsV), .isLoading(rhsV)):
      return lhsV == rhsV
    case let (.loaded(lhsV), .loaded(rhsV)):
      return lhsV == rhsV
    case let (.failed(lhsE), .failed(rhsE)):
      return lhsE.localizedDescription == rhsE.localizedDescription
    default:
      return false
    }
  }
}
