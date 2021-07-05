import SwiftUI

enum DiscoverItem {
  case moments

  case channels

  case scan
  case shake

  case news
  case search

  case liveNearby

  case shopping
  case games

  var title: String {
    switch self {
    case .moments:     return Strings.discover_moments()
    case .channels:    return Strings.discover_channels()
    case .scan:        return Strings.discover_scan()
    case .shake:       return Strings.discover_shake()
    case .news:        return Strings.discover_news()
    case .search:      return Strings.discover_search()
    case .liveNearby:  return Strings.discover_live_nearby()
    case .shopping:    return Strings.discover_shopping()
    case .games:       return Strings.discover_games()
    }
  }

  var iconImage: ImageWrapper {
    let size = CGSize(width: 24, height: 24)
    switch self {
    case .moments:
      return .init(image: Image("icons_outlined_colorful_moment"), size: size)

    case .channels:
      return .init(image: Image("icons_outlined_channel"), size: size, foregroundColor: .hex("#EC9F50"))

    case .scan:
      return .init(image: Image("icons_outlined_scan"), size: size, foregroundColor: .hex("#3C86E6"))

    case .shake:
      return .init(image: Image("icons_outlined_shake"), size: size, foregroundColor: .hex("#3C86E6"))

    case .news:
      return .init(image: Image("icons_outlined_news"), size: size, foregroundColor: .hex("#F5C343"))

    case .search:
      return .init(image: Image("icons_outlined_searchlogo"), size: size, foregroundColor: .hex("#E75D58"))

    case .liveNearby:
      return .init(image: Image("icons_outlined_live_nearby"), size: size, foregroundColor: .hex("#3C86E6"))

    case .shopping:
      return .init(image: Image("icons_outlined_shop"), size: size, foregroundColor: .hex("#E75D58"))

    case .games:
      return .init(image: Image("icons_outlined_colorful_game"), size: size)
    }
  }
}

enum DiscoverSection: CaseIterable {
  case moments
  case channels
  case scanShake
  case newsSearch
  case liveNearby
  case shoppingGames

  var items: [DiscoverItem] {
    switch self {
    case .moments:
      return [.moments]
    case .channels:
      return [.channels]
    case .scanShake:
      return [.scan, .shake]
    case .newsSearch:
      return [.news, .search]
    case .liveNearby:
      return [.liveNearby]
    case .shoppingGames:
      return [.shopping, .games]
    }
  }

  var isFirstSection: Bool {
    self == .moments
  }
}
