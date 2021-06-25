import SwiftUI

enum ContactCategory: CaseIterable {
  case groupChats
  case tags
  case officalAccount
  case weChatWorkContacts

  var icon: String {
    switch self {
    case .groupChats:
      return "icons_filled_group_detail"

    case .tags:
      return "icons_filled_tag"

    case .officalAccount:
      return "icons_filled_official_accounts"

    case .weChatWorkContacts:
      return "WeWork"
    }
  }

  var iconBgColor: Color {
    let hex: String

    switch self {
    case .groupChats:
      hex = "57BD6A"
    case .tags, .officalAccount:
      hex = "3C85E6"
    case .weChatWorkContacts:
      hex = "4182D0"
    }

    return Color.hex(hex)!
  }

  var title: String {
    switch self {
    case .groupChats:
      return Strings.contacts_group_chats()

    case .tags:
      return Strings.contacts_tags()

    case .officalAccount:
      return Strings.contacts_offical_account()

    case .weChatWorkContacts:
      return Strings.contacts_wechat_work_contacts()
    }
  }
}
