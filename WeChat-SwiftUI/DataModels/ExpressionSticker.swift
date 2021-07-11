import Foundation

struct ExpressionSticker: Decodable {
  let image: String
  let desc: Description

  func desciptionForCurrentLanguage() -> String {
    switch AppEnvironment.current.language {
    case .en:
      return desc.en
    case .zh:
      return desc.zh
    }
  }
}

extension ExpressionSticker {
  struct Description: Decodable {
    let en: String
    let zh: String
  }
}

extension ExpressionSticker: Hashable {
  static func == (lhs: ExpressionSticker, rhs: ExpressionSticker) -> Bool {
    lhs.image == rhs.image
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(image)
  }
}
