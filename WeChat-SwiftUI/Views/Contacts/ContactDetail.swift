import SwiftUI
import ComposableArchitecture
import URLImage

/* TODO:
--- 导航栏背景改为白色
--- 因为暂时无法改变 header 的高度，所以 SectionHeader 使用 cell 代替
 */

struct ContactDetail: View {

  var body: some View {
    WithViewStore(store.wrappedValue, observe: { $0.chatsState.dialogs }) { viewStore in
      List {
        Group {
          sectionInfoEditPrivacy
          SectionHeaderBackground()
          sectionMomentsMore
          SectionHeaderBackground()
          sectionMessagesCall(viewStore)
        }
        .listRowBackground(Color.app_white)
        .listSectionSeparator(.hidden)
      }
      .background(.app_bg)
      .listStyle(.plain)
      .environment(\.defaultMinListRowHeight, 10)
    }
  }

  let contact: User

  @EnvironmentObject
  private var store: StoreObservableObject<AppState, AppAction>

  @State
  private var navigationSelection: NavigationSelection?
}

private extension ContactDetail {

  var sectionInfoEditPrivacy: some View {
    Section {
      infoRow
      ForEach([TextRowItem.editContact, TextRowItem.privacy], id: \.self) { item in
        rowTitle(item.title)
      }
    }
  }

  var sectionMomentsMore: some View {
    Section {
      ForEach([TextRowItem.moment, TextRowItem.more], id: \.self) { item in
        rowTitle(item.title)
      }
    }
  }

  func sectionMessagesCall(_ viewStore: ViewStore<[Dialog], AppAction>) -> some View {
    Section {
      VStack(spacing: 0) {
        sendMessageButton(viewStore)
        Color.bg_info_200.frame(height: 0.8)
        callButton
      }
      .foregroundColor(.link)
      .font(.system(size: Constant.actionButtonFontSize, weight: .medium))
      .buttonStyle(BorderlessButtonStyle()) // 解决：点击其中一个按钮导致两个按钮触发点击事件和 cell 被点击选中
    }
  }

  var infoRow: some View {
    HStack(spacing: 20) {
      URLPlaceholderImage(contact.avatar, size: Constant.avatarSize) {
        Image.avatarPlaceholder
      }
      .foregroundColor(.app_bg)
      .background(.app_bg)
      .cornerRadius(Constant.avatarCornerRaidus)

      VStack(alignment: .leading, spacing: 5) {
        contactName
        contactWeChatId
        contactRegion
      }
    }
    .padding(.bottom, Constant.infoRowBottomPadding)
  }

  var contactName: some View {
    HStack {
      Text(contact.name)
        .foregroundColor(.text_primary)
        .font(.system(size: Constant.nameFontSize, weight: .semibold))
      if let genderIcon = contact.gender.iconName {
        Image(genderIcon)
          .resize(.fill, Constant.genderIconSize)
      }
    }
  }

  var contactWeChatId: some View {
    Text("\(Strings.general_wechat_id()): \(contact.wechatId)")
      .foregroundColor(.text_info_200)
      .font(.system(size: Constant.wechatIdRegionFontSize))
  }

  var contactRegion: some View {
    Text("\(Strings.general_region()): \(contact.region)")
      .foregroundColor(.text_info_200)
      .font(.system(size: Constant.wechatIdRegionFontSize))
  }

  func rowTitle(_ title: String) -> some View {
    ImageTitleRow(
      title: title,
      destination: { Text(title) }
    )
  }

  func sendMessageButton(_ viewStore: ViewStore<[Dialog], AppAction>) -> some View {
    let cachedDialog = viewStore.state
      .first { $0.isIndividual(with: .init(user: contact)) }
    let dialog = cachedDialog ?? Dialog(members: [
      .init(user: contact),
      .currentUser!
    ])

    return NavigationRow(
      tag: NavigationSelection.messages,
      selection: $navigationSelection,
      destination: { DialogView(viewModel: .init(dialog: dialog)) }
    ) {
      Button {
        navigationSelection = .messages
      } label: {
        HStack {
          Spacer()
          Image("icons_outlined_chats")
          Text(Strings.contact_detail_messages())
          Spacer()
        }
        .frame(height: Constant.actionButtonHeight)
      }
    }
  }

  var callButton: some View {
    Button {
      print("voice or video call")
    } label: {
      HStack {
        Image("icons_outlined_videocall")
        Text(Strings.contact_detail_voice_or_video_call())
      }
      .frame(height: Constant.actionButtonHeight)
    }
  }
}

private extension ContactDetail {
  enum Constant {
    static let avatarSize: CGSize = .init(width: 60, height: 60)
    static let avatarCornerRaidus: CGFloat = 6

    static let infoRowBottomPadding: CGFloat = 20
    static let nameFontSize: CGFloat = 20
    static let genderIconSize: CGSize = .init(width: 18, height: 18)
    static let wechatIdRegionFontSize: CGFloat = 14

    static let actionButtonFontSize: CGFloat = 16
    static let actionButtonHeight: CGFloat = 52
  }
}

extension ContactDetail {
  enum NavigationSelection {
    case messages
  }
}

extension ContactDetail {
  enum TextRowItem {
    case editContact
    case privacy
    case moment
    case more

    var title: String {
      switch self {
      case .editContact: return Strings.contact_detail_edit_contact()
      case .privacy:     return Strings.contact_detail_privacy()
      case .moment:      return Strings.contact_detail_moments()
      case .more:        return Strings.contact_detail_more()
      }
    }
  }
}

struct ContactDetail_Previews: PreviewProvider {
  static var previews: some View {
    AppEnvironment.updateCurrentUser(.template1)
    let store = Store(
      initialState: AppState(),
      reducer: appReducer
    )
    return ContactDetail(contact: .template1)
      .environmentObject(StoreObservableObject(store: store))
  }
}
