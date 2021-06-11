import Combine

/// 存储订阅的工具类
final class CancelBag {
  var subscriptions = Set<AnyCancellable>()

  func cancel() {
    subscriptions.forEach { $0.cancel() }
    subscriptions.removeAll()
  }
}

extension AnyCancellable {

  func store(in cancelBag: CancelBag) {
    cancelBag.subscriptions.insert(self)
  }
}
