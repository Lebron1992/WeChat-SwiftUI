import Foundation

/// 查找本地化字符串并使用替换对其进行插值。
/// - Parameters:
///   - key: 要查找的字符串对应的键
///   - defaultValue: 没有找到键对应的字符串时所使用的默认值
///   - substitutions: 要进行的键/值替换的字典。
///   - env: `Environment` 对象，用户获取当前的语言
/// - Returns: 本地化字符串。如果键不存在，则返回 `defaultValue`，如果没有指定，将返回一个空字符串。
func localizedString(
  key: String,
  defaultValue: String = "",
  count: Int? = nil,
  substitutions: [String: String] = [:],
  env: Environment = AppEnvironment.current
) -> String {
  // 当传入的 `count` 有值时，我们需要用复数后缀来更新键。
  let augmentedKey = count
    .flatMap { key + "." + keySuffixForCount($0) }
    .coalesceWith(key)

  let lprojName = lprojFileNameForLanguage(env.language)
  let localized = Bundle.main.path(forResource: lprojName, ofType: "lproj")
    .flatMap { Bundle(path: $0) }
    .flatMap { $0.localizedString(forKey: augmentedKey, value: nil, table: nil) }
    .filter {
      //注意：`localizedStringForKey` 有一个恼人的习惯，就是在键不存在时返回键。
      //我们过滤掉这些，希望永远不要使用与其键相等的值。
      $0.caseInsensitiveCompare(augmentedKey) != .orderedSame
    }
    .filter { !$0.isEmpty }
    .coalesceWith(defaultValue)

  return substitute(localized, with: substitutions)
}

private func lprojFileNameForLanguage(_ language: Language) -> String {
  return language.rawValue == "zh" ? "zh-Hans" : language.rawValue
}

/// 返回计数的复数形式。
private func keySuffixForCount(_ count: Int) -> String {
  switch count {
  case 0:
    return "zero"
  case 1:
    return "one"
  case 2:
    return "two"
  case 3...5:
    return "few"
  default:
    return "many"
  }
}

/// 对格式为 `%{key}` 的键执行简单的字符串插值。
private func substitute(_ string: String, with substitutions: [String: String]) -> String {
  return substitutions.reduce(string) { accum, sub in
    accum.replacingOccurrences(of: "%{\(sub.0)}", with: sub.1)
  }
}
