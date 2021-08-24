extension MyProfileFieldUpdateView {
  enum Field {
    case name(String)
    case gender(User.Gender)
    case region
    case whatsUp(String)

    var navigationBarTitle: String {
      let name: String
      switch self {
      case .name:
        name = Strings.general_name()
      case .gender:
        name = Strings.general_gender()
      case .region:
        name = Strings.general_region()
      case .whatsUp:
        name = Strings.general_whats_up()
      }
      return "\(Strings.general_set()) \(name)"
    }
  }
}
