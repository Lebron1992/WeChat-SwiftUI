import SwiftUI
import ComposableArchitecture
import URLImage

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

    func detailView(with user: User) -> AnyView {
      switch self {
      case .photo:
        return URLPlaceholderImage(user.avatar, size: Constant.avatarSize) {
          Image.avatarPlaceholder
        }
        .background(.app_bg)
        .cornerRadius(Constant.avatarCornerRadius)
        .asAnyView()

      case .name:
        return Text(user.name)
          .font(.system(size: Constant.detailTextFontSize))
          .foregroundColor(.text_info_200)
          .asAnyView()

      case .wechatId:
        return Text(user.wechatId)
          .font(.system(size: Constant.detailTextFontSize))
          .lineLimit(1)
          .foregroundColor(.text_info_200)
          .asAnyView()

      case .qrCode:
        return Image("icons_outlined_qr_code")
          .resize(.fill, Constant.qrCodeImageSize)
          .foregroundColor(.text_info_200)
          .asAnyView()

      case .more:
        return EmptyView().asAnyView()
      }
    }

    func navigateDestination(with user: User) -> MyProfileRowType.Destination {
      switch self {
      case .photo:
        return (.push, MyProfilePhotoPreview(photoUrl: user.avatar).asAnyView())
      case .name:
        return (.modal, MyProfileFieldUpdateView(field: .name(user.name)).asAnyView())
      case .wechatId:
        return (.push, Text("wechatId").asAnyView())
      case .qrCode:
        return (.push, Text("qrCode").asAnyView())
      case .more:
        let list = List {
          ForEach(subRows, id: \.self) { subRow in
            ProfileRow(row: subRow, user: user)
          }
          .listRowBackground(Color.app_white)
        }
          .background(.app_bg)
          .listStyle(.plain)
          .asAnyView()
        return (.push, list)
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

    func detailView(with user: User) -> AnyView {
      let text: String
      switch self {
      case .gender:
        text = user.gender.description
      case .region:
        text = user.region
      case .whatsUp:
        text = user.whatsUp.isEmpty ? Strings.general_not_set() : user.whatsUp
      }
      return Text(text)
        .font(.system(size: Constant.detailTextFontSize))
          .foregroundColor(.text_info_200)
          .asAnyView()
    }

    func navigateDestination(with user: User) -> MyProfileRowType.Destination {
      switch self {
      case .gender:
        return (.modal, MyProfileFieldUpdateView(field: .gender(user.gender)).asAnyView())
      case .region:
        return (.modal, MyProfileFieldUpdateView(field: .region).asAnyView())
      case .whatsUp:
        return (.modal, MyProfileFieldUpdateView(field: .whatsUp(user.whatsUp)).asAnyView())
      }
    }
  }
}

protocol MyProfileRowType {
  typealias Destination = (style: PresentationStyle, content: AnyView)

  var title: String { get }
  func detailView(with user: User) -> AnyView
  func navigateDestination(with user: User) -> Destination
}

private extension MyProfileView.Row {
  enum Constant {
    static let avatarSize: CGSize = .init(width: 64, height: 64)
    static let avatarCornerRadius: CGFloat = 6
    static let detailTextFontSize: CGFloat = 16
    static let qrCodeImageSize: CGSize = .init(width: 20, height: 20)
  }
}
