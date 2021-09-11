import SwiftUI
import SwiftUIRedux

struct MyProfileView: ConnectedView {
  struct Props {
    let signedInUser: User?
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      signedInUser: state.authState.signedInUser
    )
  }

  @ViewBuilder
  func body(props: Props) -> some View {
    if let user = props.signedInUser {
        List {
          ForEach(Row.allCases, id: \.self) { row in
            ProfileRow(row: row, user: user)
          }
          .listRowBackground(Color.app_white)
        }
        .background(.app_bg)
        .listStyle(.plain)
        .navigationTitle(Strings.me_my_profile_title())
    } else {
      EmptyView()
    }
  }
}

struct MyProfileView_Previews: PreviewProvider {
  static var previews: some View {
    MyProfileView()
  }
}
