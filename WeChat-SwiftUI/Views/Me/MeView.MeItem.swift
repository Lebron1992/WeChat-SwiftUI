import SwiftUI

extension MeView {
  enum MeItem {
    case pay
    case favorites
    case stickerGallery
    case settings

    var title: String {
      switch self {
      case .pay: return Strings.me_pay()
      case .favorites: return Strings.me_favorites()
      case .stickerGallery: return Strings.me_sticker_gallery()
      case .settings: return Strings.me_settings()
      }
    }

    var iconImage: Image {
      switch self {
      case .pay:
        return Image("icons_outlined_wechatpay")
      case .favorites:
        return Image("icons_outlined_colorful_favorites")
      case .stickerGallery:
        return Image("icons_outlined_sticker")
      case .settings:
        return Image("icons_outlined_setting")
      }
    }

    var iconForegroundColor: Color? {
      switch self {
      case .pay, .favorites:
        return nil
      case .stickerGallery:
        return .hex("F5C343")
      case .settings:
        return .hex("3C86E6")
      }
    }
  }
}
