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

  var iconImage: Image {
    switch self {
    case .moments:
      return Image("icons_outlined_colorful_moment")

    case .channels:
      return Image("icons_outlined_channel")

    case .scan:
      return Image("icons_outlined_scan")

    case .shake:
      return Image("icons_outlined_shake")

    case .news:
      return Image("icons_outlined_news")

    case .search:
      return Image("icons_outlined_searchlogo")

    case .liveNearby:
      return Image("icons_outlined_live_nearby")

    case .shopping:
      return Image("icons_outlined_shop")

    case .games:
      return Image("icons_outlined_colorful_game")
    }
  }

  var iconForegroundColor: Color? {
    switch self {
    case .moments:
      return nil

    case .channels:
      return .hex("#EC9F50")

    case .scan, .shake, .liveNearby:
      return .hex("#3C86E6")

    case .news:
      return .hex("#F5C343")

    case .search, .shopping:
      return .hex("#E75D58")

    case .games:
      return nil
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
