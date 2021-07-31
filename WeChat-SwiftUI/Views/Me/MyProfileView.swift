import SwiftUI

struct MyProfileView: View {
  var body: some View {
    List {
      ForEach(Row.allCases, id: \.self) { row in
        ProfileRow(row: row)
      }
      .listRowBackground(Color.app_white)
    }
    .background(.app_bg)
    .listStyle(.plain)
  }
}

// MARK: - Models

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

    var detailView: AnyView {
      let currentUser = AppEnvironment.current.currentUser!
      switch self {
      case .photo:
        return AnyView(
          Image.avatarPlaceholder
            .resize(.fill, .init(width: 64, height: 64))
        )
      case .name:
        return AnyView(
          Text(currentUser.name)
            .font(.system(size: 16))
            .foregroundColor(.text_info_200)
        )
      case .wechatId:
        return AnyView(
          Text(currentUser.wechatId)
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

    var destinationPresentation: (style: PresentationStyle, destination: AnyView) {
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
              ProfileRow(row: subRow)
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

    var detailView: AnyView {
      let currentUser = AppEnvironment.current.currentUser!
      let text: String
      switch self {
      case .gender:
        text = currentUser.gender.description
      case .region:
        text = currentUser.region
      case .whatsUp:
        text = currentUser.whatsUp.isEmpty ? Strings.general_not_set() : currentUser.whatsUp
      }
      return AnyView(
        Text(text)
          .font(.system(size: 16))
          .foregroundColor(.text_info_200)
      )
    }

    var destinationPresentation: (style: PresentationStyle, destination: AnyView) {
      switch self {
      case .gender:
        let gender = AppEnvironment.current.currentUser?.gender ?? .unknown
        return (.modal, AnyView(MyProfileFieldUpdateView(field: .gender(gender))))
      case .region:
        return (.modal, AnyView(Text("region")))
      case .whatsUp:
        let whatsUp = AppEnvironment.current.currentUser?.whatsUp ?? ""
        return (.modal, AnyView(MyProfileFieldUpdateView(field: .whatsUp(whatsUp))))
      }
    }
  }
}

// MARK: - Helper Types

protocol MyProfileRowType {
  var title: String { get }
  var detailView: AnyView { get }
  var destinationPresentation: (style: PresentationStyle, destination: AnyView) { get }
}

extension MyProfileView {
  struct ProfileRow: View {
    let row: MyProfileRowType

    @State private var showingSheet = false

    var body: some View {
      let view: AnyView

      switch row.destinationPresentation.style {
      case .modal:
        view = AnyView(
          HStack {
            Text(row.title)
              .font(.system(size: 16))
              .foregroundColor(.text_primary)
            Spacer()
            row.detailView
            Image(systemName: "chevron.right")
              .font(.system(size: 14, weight: .medium))
              .foregroundColor(.text_info_200)
          }
            .onTapGesture {
              showingSheet = true
            }
            .fullScreenCover(isPresented: $showingSheet, content: { row.destinationPresentation.destination })
        )
      case .push:
        view = AnyView(
          NavigationLink(destination: row.destinationPresentation.destination) {
            HStack {
              Text(row.title)
                .font(.system(size: 16))
                .foregroundColor(.text_primary)
              Spacer()
              row.detailView
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
