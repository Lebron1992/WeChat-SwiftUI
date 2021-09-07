import Foundation

/// 把一个对象包装在此类型中，用于把这个对象传递给 `view` 的子层级
final class ObjectBox<T>: ObservableObject {
  let value: T

  init(value: T) {
    self.value = value
  }
}
