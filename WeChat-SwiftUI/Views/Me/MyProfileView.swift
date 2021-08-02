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

extension MyProfileView {
  enum Row: CaseIterable, MyProfileRowType {
    case photo
    case name
    case wechatId
    case qrCode
    case more

    var subRows: [SubRow] {
      switch self {
      case .more:
        return [.gender, .region, .whatsUp]
      default:
        return []
      }
    }

    var title: String {
      switch self {
      case .photo:
        return Strings.me_profile_photo()
      case .name:
        return Strings.general_name()
      case .wechatId:
        return Strings.general_wechat_id()
      case .qrCode:
        return Strings.me_my_qr_code()
      case .more:
        return Strings.general_more()
      }
    }

    func detailView(user: User) -> AnyView {
      switch self {
      case .photo:
        return AnyView(
          Image.avatarPlaceholder
            .resize(.fill, .init(width: 64, height: 64))
        )
      case .name:
        return AnyView(
          Text(user.name)
            .font(.system(size: 16))
            .foregroundColor(.text_info_200)
        )
      case .wechatId:
        return AnyView(
          Text(user.wechatId)
            .font(.system(size: 16))
            .lineLimit(1)
            .foregroundColor(.text_info_200)
        )
      case .qrCode:
        return AnyView(
          Image("icons_outlined_qr_code")
            .resize(.fill, .init(width: 20, height: 20))
            .foregroundColor(.text_info_200)
        )
      case .more:
        return AnyView(EmptyView())
      }
    }

    func destinationPresentation(user: User) -> (style: PresentationStyle, destination: AnyView) {
      switch self {
      case .photo:
        return (.push, AnyView(Text("photo")))
      case .name:
        let name = AppEnvironment.current.currentUser?.name ?? ""
        return (.modal, AnyView(MyProfileFieldUpdateView(field: .name(name))))
      case .wechatId:
        return (.push, AnyView(Text("wechatId")))
      case .qrCode:
        return (.push, AnyView(Text("qrCode")))
      case .more:
        return (.push, AnyView(
          List {
            ForEach(subRows, id: \.self) { subRow in
              ProfileRow(row: subRow, user: user)
            }
            .listRowBackground(Color.app_white)
          }
            .background(.app_bg)
            .listStyle(.plain)
        ))
      }
    }
  }
}

extension MyProfileView.Row {
  enum SubRow: MyProfileRowType {
    case gender
    case region
    case whatsUp

    var title: String {
      switch self {
      case .gender:
        return Strings.general_gender()
      case .region:
        return Strings.general_region()
      case .whatsUp:
        return Strings.general_whats_up()
      }
    }

    func detailView(user: User) -> AnyView {
      let text: String
      switch self {
      case .gender:
        text = user.gender.description
      case .region:
        text = user.region
      case .whatsUp:
        text = user.whatsUp.isEmpty ? Strings.general_not_set() : user.whatsUp
      }
      return AnyView(
        Text(text)
          .font(.system(size: 16))
          .foregroundColor(.text_info_200)
      )
    }

    func destinationPresentation(user: User) -> (style: PresentationStyle, destination: AnyView) {
      switch self {
      case .gender:
        return (.modal, AnyView(MyProfileFieldUpdateView(field: .gender(user.gender))))
      case .region:
        return (.modal, AnyView(MyProfileFieldUpdateView(field: .region)))
      case .whatsUp:
        return (.modal, AnyView(MyProfileFieldUpdateView(field: .whatsUp(user.whatsUp))))
      }
    }
  }
}

protocol MyProfileRowType {
  var title: String { get }
  func detailView(user: User) -> AnyView
  func destinationPresentation(user: User) -> (style: PresentationStyle, destination: AnyView)
}

struct MyProfileView_Previews: PreviewProvider {
  static var previews: some View {
    MyProfileView()
  }
}
