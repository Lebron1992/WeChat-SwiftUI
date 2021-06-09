/// 应用所支持的语言
enum Language: String {
  case en
  case zh

  init?(languageString language: String) {
    switch language.lowercased() {
    case "en": self = .en
    case "zh": self = .zh
    default: return nil
    }
  }

  init?(languageStrings languages: [String]) {
    guard let language = languages
            .lazy
            .map({ String($0.prefix(2)) })
            .compactMap(Language.init(languageString:))
            .first else {
      return nil
    }

    self = language
  }

  var displayString: String {
    switch self {
    case .en: return "English"
    case .zh: return "简体中文"
    }
  }
}
