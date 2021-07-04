import Foundation

struct DiscoverState {
  var discoverSections: [DiscoverSection]
}

extension DiscoverState: Equatable {
  static func == (lhs: DiscoverState, rhs: DiscoverState) -> Bool {
    lhs.discoverSections == rhs.discoverSections
  }
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
