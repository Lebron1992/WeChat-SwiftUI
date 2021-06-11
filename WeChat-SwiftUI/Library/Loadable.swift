import Foundation
import SwiftUI

/// 表示通过一系列请求才能得到的数据模型的几种状态，用户可以根据不同的状态来更新 UI
enum Loadable<T> {

  case notRequested
  case isLoading(last: T?, cancelBag: CancelBag)
  case loaded(T)
  case failed(Error)

  var value: T? {
    switch self {
    case let .loaded(value): return value
    case let .isLoading(last, _): return last
    default: return nil
    }
  }

  var error: Error? {
    switch self {
    case let .failed(error): return error
    default: return nil
    }
  }
}

extension Loadable {

  mutating func setIsLoading(cancelBag: CancelBag) {
    self = .isLoading(last: value, cancelBag: cancelBag)
  }

  mutating func cancelLoading() {
    switch self {
    case let .isLoading(last, cancelBag):
      cancelBag.cancel()
      if let last = last {
        self = .loaded(last)
      } else {
        let error = NSError(
          domain: NSCocoaErrorDomain,
          code: NSUserCancelledError,
          userInfo: [NSLocalizedDescriptionKey: "Canceled by user"]
        )
        self = .failed(error)
      }
    default: break
    }
  }

  func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
    do {
      switch self {
      case .notRequested: return .notRequested
      case let .failed(error): return .failed(error)
      case let .isLoading(value, cancelBag):
        return .isLoading(last: try value.map { try transform($0) },
                          cancelBag: cancelBag)
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
    case (.notRequested, .notRequested): return true
    case let (.isLoading(lhsV, _), .isLoading(rhsV, _)): return lhsV == rhsV
    case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
    case let (.failed(lhsE), .failed(rhsE)):
      return lhsE.localizedDescription == rhsE.localizedDescription
    default: return false
    }
  }
}

protocol SomeOptional {
  associatedtype Wrapped
  func unwrap() throws -> Wrapped
}

struct ValueIsMissingError: Error {
  var localizedDescription: String {
    "Data is missing"
  }
}

extension Optional: SomeOptional {
  func unwrap() throws -> Wrapped {
    switch self {
    case let .some(value): return value
    case .none: throw ValueIsMissingError()
    }
  }
}

extension Loadable where T: SomeOptional {
  func unwrap() -> Loadable<T.Wrapped> {
    map { try $0.unwrap() }
  }
}
