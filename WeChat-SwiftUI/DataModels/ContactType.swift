protocol ContactType: Identifiable {
  var name: String { get }
  var avatar: String { get }

  /// 在列表中的索引
  var index: String { get }

  /// 是否匹配搜索关键字
  func match(_ query: String) -> Bool
}
