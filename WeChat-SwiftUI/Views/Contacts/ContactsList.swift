import SwiftUI
import SwiftUIRedux

struct ContactsList: ConnectedView {
  struct Props {
    let contacts: Loadable<[User]>
    let loadContacts: () -> Void
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      contacts: state.contactsState.contacts,
      loadContacts: { dispatch(ContactsActions.LoadContacts()) }
    )
  }

  func body(props: Props) -> some View {
    switch props.contacts {
    case .notRequested:
      return AnyView(Text("").onAppear(perform: props.loadContacts))

    case let .isLoading(last, _):
      return AnyView(loadingView(last))

    case let .loaded(users):
      return AnyView(loadedView(users, showLoading: false))

    case let .failed(error):
      return AnyView(ErrorView(error: error, retryAction: props.loadContacts))
    }
  }
}

// MARK: - Display Content
private extension ContactsList {

  func loadingView(_ previouslyLoaded: [User]?) -> some View {
    if let result = previouslyLoaded {
      return AnyView(loadedView(result, showLoading: true))
    } else {
      return AnyView(ActivityIndicatorView().padding())
    }
  }

  func loadedView(_ contacts: [User], showLoading: Bool) -> some View {

    let contactGroups = contacts
      .groupedBy { String($0.name.first ?? Character("")) }
      .sorted(by: { $0.key < $1.key })

    return ScrollViewReader { proxy in
      ZStack {
        groupedContactsList(contactGroups)
        if showLoading {
          ActivityIndicatorView(color: .gray)
            .padding()
        }
      }
      .overlay(sectionIndexTitles(titles: contactGroups.map { $0.key }, proxy: proxy))
    }
  }

  func groupedContactsList(_ group: [(key: String, value: [User])]) -> some View {
    List {
      ForEach(group, id: \.key) { category, contacts in
        Section(header: SectionHeader(title: category)) {
          ForEach(contacts) { contact in
            ZStack(alignment: .leading) {
              NavigationLink(destination: ContactDetail(contact: contact)) {
                EmptyView()
              }
              .opacity(0.0) // 为了隐藏 NavigationLink 右边的箭头
              .buttonStyle(PlainButtonStyle())
              ContactRow(contact: contact)
            }
          }
        }
      }
    }
    .listStyle(PlainListStyle())
  }

  func sectionIndexTitles(titles: [String], proxy: ScrollViewProxy) -> some View {
    SectionIndexTitles(proxy: proxy, titles: titles)
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.trailing, 2)
  }
}

// MARK: - Helper Types
private extension ContactsList {

  // MARK: - SectionHeader

  struct SectionHeader: View {
    let title: String

    var body: some View {
      Text(title)
        .foregroundColor(.text_info_200)
        .font(.system(size: 14, weight: .medium))
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 0))
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .background(Color.bg_info_200)
    }
  }

  // MARK: - SectionIndexTitles

  struct SectionIndexTitles: View {

    let proxy: ScrollViewProxy
    let titles: [String]

    @GestureState
    private var dragLocation: CGPoint = .zero

    @State
    private var selectedTitle: String?

    var body: some View {
      VStack {
        ForEach(titles, id: \.self) { title in
          let isSelected = selectedTitle == nil ? nil : selectedTitle! == title
          SectionIndexTitle(
            title: title,
            isSelected: isSelected,
            onTap: { scrollToTitle(title) }
          )
          .background(dragObserver(title: title))
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
          .updating($dragLocation) { value, state, _ in
            state = value.location
          }
      )
    }

    private func dragObserver(title: String) -> some View {
      GeometryReader { geometry in
        dragObserver(geometry: geometry, title: title)
      }
    }

    private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
      if geometry.frame(in: .global).contains(dragLocation) {
        DispatchQueue.main.async {
          scrollToTitle(title)
        }
      }
      return Rectangle().fill(Color.clear)
    }

    private func scrollToTitle(_ title: String) {
      guard selectedTitle != title else {
        return
      }
      proxy.scrollTo(title, anchor: .top)
      selectedTitle = title
      Haptics.impact(.light)
    }
  }

  // MARK: - SectionIndexTitle

  struct SectionIndexTitle: View {
    let title: String
    let isSelected: Bool?
    let onTap: () -> Void

    var body: some View {
      Text(title)
        .font(.system(size: 11, weight: .semibold))
        .foregroundColor(foregroundColor)
        .frame(width: 16, height: 16)
        .background(background)
        .cornerRadius(cornerRadius)
        .contentShape(Rectangle()) // 解决问题：背景色为透明时，手势无效
        .onTapGesture(perform: onTap)
    }

    private var foregroundColor: Color {
      isSelected == nil ?
        .text_info_500 :
        isSelected! ? .white : .text_info_500
    }

    private var background: Color {
      isSelected == nil ?
        .clear :
        isSelected! ? .highlighted : .clear
    }

    private var cornerRadius: CGFloat {
      isSelected == nil ?
        0 :
        isSelected! ? 8 : 0
    }
  }
}

struct ContactsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactsList()
  }
}
