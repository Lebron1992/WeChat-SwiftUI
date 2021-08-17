import Foundation

struct DiscoverState: Equatable {
  var discoverSections: [DiscoverSection]
}

#if DEBUG
extension DiscoverState {
  static var preview: DiscoverState {
    DiscoverState(
      discoverSections: DiscoverSection.allCases
    )
  }
}
#endif
