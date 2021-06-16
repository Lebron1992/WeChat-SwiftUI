import SwiftUI

enum TabBarItem: Int {
  case chats
  case contacts
  case discover
  case me

  var title: String {
    switch self {
    case .chats:
      return Strings.tabbar_chats()
    case .contacts:
      return Strings.tabbar_contacts()
    case .discover:
      return Strings.tabbar_discover()
    case .me:
      return Strings.tabbar_me()
    }
  }

  var defaultImage: Image {
    let name: String
    switch self {
    case .chats:
      name = "icons_outlined_chats"
    case .contacts:
      name = "icons_outlined_contacts"
    case .discover:
      name = "icons_outlined_discover"
    case .me:
      name = "icons_outlined_me"
    }
    return Image(name)
  }

  var selectedImage: Image {
    let name: String
    switch self {
    case .chats:
      name = "icons_filled_chats"
    case .contacts:
      name = "icons_filled_contacts"
    case .discover:
      name = "icons_filled_discover"
    case .me:
      name = "icons_filled_me"
    }
    return Image(name)
  }
}
