@testable import WeChat_SwiftUI

private let stores = [
  "en": [
    "test_count.zero": "zero",
    "test_count.one": "one",
    "test_count.two": "two",
    "test_count.few": "%{the_count} few",
    "test_count.many": "%{the_count} many",
    "hello": "world",
    "echo": "echo",
    "hello_format": "hello %{a} %{b}",
    "placeholder_password": "password",
    "dates.just_now": "just now",
    "dates.time_hours_ago.zero": "%{time_count} hours ago",
    "dates.time_hours_ago.one": "%{time_count} hour ago",
    "dates.time_hours_ago.two": "%{time_count} hours ago",
    "dates.time_hours_ago.few": "%{time_count} hours ago",
    "dates.time_hours_ago.many": "%{time_count} hours ago",
    "dates.time_hours_ago_abbreviated.zero": "%{time_count} hrs ago",
    "dates.time_hours_ago_abbreviated.one": "%{time_count} hr ago",
    "dates.time_hours_ago_abbreviated.two": "%{time_count} hrs ago",
    "dates.time_hours_ago_abbreviated.few": "%{time_count} hrs ago",
    "dates.time_hours_ago_abbreviated.many": "%{time_count} hrs ago"
  ],
  "zh-Hans": [
    "test_count.zero": "zh_zero",
    "test_count.one": "zh_one",
    "test_count.two": "zh_two",
    "test_count.few": "zh_%{the_count} few",
    "test_count.many": "zh_%{the_count} many",
    "hello": "zh_world",
    "echo": "echo",
    "hello_format": "zh_hello %{a} %{b}",
    "dates.time_hours_ago.one": "%{time_count} 个小时前",
    "dates.time_hours_ago_abbreviated.one": "%{time_count} 小时前"
  ]
]

struct MockBundle: NSBundleType {
  private let store: [String: String]

  func path(forResource name: String?, ofType _: String?) -> String? {
    return name
  }

  init(lang: String = "en") {
    self.store = stores[lang] ?? [:]
  }

  static func create(path: String) -> NSBundleType? {
    return MockBundle(lang: path)
  }

  func localizedString(forKey key: String, value: String?, table _: String?) -> String {
    // A real `NSBundle` will return the key if the key is missing and value is `nil`.
    return self.store[key] ?? value ?? key
  }
}
