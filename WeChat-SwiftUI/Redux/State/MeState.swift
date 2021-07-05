struct MeState {
  var userSelf: Loadable<User>
}

extension MeState: Equatable {
  static func == (lhs: MeState, rhs: MeState) -> Bool {
    lhs.userSelf == lhs.userSelf
  }
}

#if DEBUG
extension MeState {
  static var preview: MeState {
    MeState(
      userSelf: .loaded(.template)
    )
  }
}
#endif
