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

  var iconImage: some View {
    switch self {
    case .moments:
      return AnyView(
        Image("icons_outlined_colorful_moment")
          .resizeToFill()
      )
    case .channels:
      return AnyView(
        Image("icons_outlined_channel")
          .resizeToFill()
          .foregroundColor(.hex("#EC9F50"))
      )
    case .scan:
      return AnyView(
        Image("icons_outlined_scan")
          .resizeToFill()
          .foregroundColor(.hex("#3C86E6"))
      )
    case .shake:
      return AnyView(
        Image("icons_outlined_shake")
          .resizeToFill()
          .foregroundColor(.hex("#3C86E6"))
      )
    case .news:
      return AnyView(
        Image("icons_outlined_news")
          .resizeToFill()
          .foregroundColor(.hex("#F5C343"))
      )
    case .search:
      return AnyView(
        Image("icons_outlined_searchlogo")
          .resizeToFill()
          .foregroundColor(.hex("#E75D58"))
      )
    case .liveNearby:
      return AnyView(
        Image("icons_outlined_live_nearby")
          .resizeToFill()
          .foregroundColor(.hex("#3C86E6"))
      )
    case .shopping:
      return AnyView(
        Image("icons_outlined_shop")
          .resizeToFill()
          .foregroundColor(.hex("#E75D58"))
      )
    case .games:
      return AnyView(
        Image("icons_outlined_colorful_game")
          .resizeToFill()
      )
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
