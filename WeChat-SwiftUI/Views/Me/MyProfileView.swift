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

  func body(props: Props) -> some View {
    if let user = props.signedInUser {
      return AnyView(
        List {
          ForEach(Row.allCases, id: \.self) { row in
            ProfileRow(row: row, user: user)
          }
          .listRowBackground(Color.app_white)
        }
        .background(.app_bg)
        .listStyle(.plain)
      )
    } else {
      return AnyView(EmptyView())
    }
  }
}

extension MyProfileView {
  struct ProfileRow: View {
    let row: MyProfileRowType
    let user: User

    @State private var showingSheet = false

    var body: some View {
      let view: AnyView

      let presentation = row.destinationPresentation(user: user)
      switch presentation.style {
      case .modal:
        view = AnyView(
          HStack {
            Text(row.title)
              .font(.system(size: 16))
              .foregroundColor(.text_primary)
            Spacer()
            row.detailView(user: user)
            Image(systemName: "chevron.right")
              .font(.system(size: 14, weight: .medium))
              .foregroundColor(.text_info_200)
          }
            .onTapGesture {
              showingSheet = true
            }
            .fullScreenCover(isPresented: $showingSheet, content: { presentation.destination })
        )
      case .push:
        view = AnyView(
          NavigationLink(destination: presentation.destination) {
            HStack {
              Text(row.title)
                .font(.system(size: 16))
                .foregroundColor(.text_primary)
              Spacer()
              row.detailView(user: user)
            }
          }
        )
      }

      return view
        .padding(.vertical, 8)
    }
  }
}

struct MyProfileView_Previews: PreviewProvider {
  static var previews: some View {
    MyProfileView()
  }
}
