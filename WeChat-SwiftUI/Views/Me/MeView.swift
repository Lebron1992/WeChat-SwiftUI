import SwiftUI
import ComposableArchitecture
import URLImage

struct MeView: View {

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        content(viewStore)
          .navigationBarHidden(true)
          .navigationBarTitleDisplayMode(.inline)
      }
      .navigationViewStyle(.stack)
      .environmentObject(StoreObservableObject(store: store.stateless))
    }
  }

  let store: Store<AuthState, AppAction>
}

private extension MeView {

  @ViewBuilder
  func content(_ viewStore: ViewStore<AuthState, AppAction>) -> some View {
    if let user = viewStore.signedInUser {
      ZStack(alignment: .topTrailing) {
        List {
          sectionMyInfo(user: user)

          ForEach([
            [MeItem.pay],
            [MeItem.favorites, MeItem.stickerGallery],
            [MeItem.settings]
          ], id: \.self) { items in

            SectionHeaderBackground()
            Section {
              ForEach(items, id: \.self) {
                meItemRow(for: $0)
              }
            }
            .listRowBackground(Color.app_white)
            .listSectionSeparator(.hidden)
          }
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 10)

        cameraButton
      }
    }
  }

  func sectionMyInfo(user: User) -> some View {
    Section {
      NavigationRow(destination: MyProfileView(store: store)) {
        HStack(spacing: 16) {
          URLPlaceholderImage(user.avatar, size: Constant.avatarSize) {
            Image.avatarPlaceholder
          }
          .foregroundColor(.app_bg)
          .background(.app_bg)
          .cornerRadius(Constant.avatarCornerRadius)

          VStack(alignment: .leading, spacing: 5) {
            usernameView(user: user)
            wechatIdView(user: user)
          }
        }
        .padding(.vertical, Constant.myInfoVerticalPadding)
      }
    }
    .listRowBackground(Color.app_white)
    .listRowSeparator(.hidden)
    .listSectionSeparator(.hidden)
  }

  func usernameView(user: User) -> some View {
    Text(user.name)
      .foregroundColor(.text_primary)
      .font(.system(size: Constant.usernameFontSize, weight: .semibold))
  }

  func wechatIdView(user: User) -> some View {
    HStack(spacing: 2) {
      Text("\(Strings.general_wechat_id()): \(user.wechatId)")
        .font(.system(size: Constant.wechatIdFontSize))
        .lineLimit(1)
      Image("icons_outlined_qr_code")
        .resize(.fill, Constant.qrCodeImageSize)
      Spacer()
      Image(systemName: "chevron.right")
        .font(.system(size: Constant.rightArrowFontSize, weight: .medium))
    }
    .foregroundColor(.text_info_200)
  }

  var cameraButton: some View {
    Image("icons_filled_camera")
      .padding(.top, Constant.cameraButtonPaddingTop)
      .padding(.trailing, Constant.cameraButtonPaddingTrailing)
  }

  func meItemRow(for item: MeItem) -> some View {
    ImageTitleRow(
      image: item.iconImage,
      imageColor: item.iconForegroundColor,
      imageSize: Constant.rowImageSize,
      title: item.title,
      destination: { Text(item.title) }
    )
  }
}

private extension MeView {
  enum Constant {
    static let avatarSize: CGSize = .init(width: 64, height: 64)
    static let avatarCornerRadius: CGFloat = 6
    static let myInfoVerticalPadding: CGFloat = 30
    static let usernameFontSize: CGFloat = 20
    static let wechatIdFontSize: CGFloat = 14
    static let rightArrowFontSize: CGFloat = 14
    static let qrCodeImageSize: CGSize = .init(width: 14, height: 14)
    static let cameraButtonPaddingTop: CGFloat = 4
    static let cameraButtonPaddingTrailing: CGFloat = 14
    static let rowImageSize: CGSize = .init(width: 24, height: 24)
  }
}

struct MeView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(authState: .init(signedInUser: .template1)),
      reducer: appReducer
    )
      .scope(state: \.authState)
    MeView(store: store)
  }
}
