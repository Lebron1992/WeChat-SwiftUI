import Foundation

struct ChatsState: Codable, Equatable {
  var dialogs: [Dialog]
}

#if DEBUG
extension ChatsState {
  static var preview: ChatsState {
    ChatsState(
      dialogs: []
    )
  }
}
#endif
