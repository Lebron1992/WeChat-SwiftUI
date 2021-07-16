import SwiftUI
import SwiftUIRedux

/* TODO:
--- section header 吸到顶部时，背景色改为白色，title 颜色改为 highlighted
--- 滚动列表时，右边的索引切换到对应的 section
--- Header 高度无法调整
*/

struct ContactsList<Contact: ContactType, Header: View, Destination: View>: View {

  let contacts: Loadable<[Contact]>
  let searchText: String
  let loadContacts: () -> Void
  let header: () -> Header?
  let selectionDestination: (Contact) -> Destination?

  init(
    contacts: Loadable<[Contact]>,
    searchText: String,
    loadContacts: @escaping () -> Void,
    header: @escaping () -> Header?,
    selectionDestination: @escaping (Contact) -> Destination?
  ) {
    self.contacts = contacts
    self.searchText = searchText
    self.loadContacts = loadContacts
    self.header = header
    self.selectionDestination = selectionDestination
  }

  var body: some View {
    switch contacts {
    case .notRequested:
      return AnyView(Text("").onAppear(perform: loadContacts))

    case let .isLoading(last, _):
      return AnyView(loadingView(contacts: last, searchText: searchText))

    case let .loaded(contacts):
      return AnyView(loadedView(contacts: contacts, searchText: searchText, showLoading: false))

    case let .failed(error):
      return AnyView(ErrorView(error: error, retryAction: loadContacts))
    }
  }
}

// MARK: - Display Content
private extension ContactsList {

  func loadingView(contacts previouslyLoaded: [Contact]?, searchText: String) -> some View {
    if let result = previouslyLoaded {
      return AnyView(loadedView(contacts: result, searchText: searchText, showLoading: true))
    } else {
      return AnyView(ActivityIndicatorView().padding())
    }
  }

  func loadedView(contacts: [Contact], searchText: String, showLoading: Bool) -> some View {

    let contactGroups = contacts.filter {
      if searchText.isEmpty {
        return true
      }
      return $0.match(searchText)
    }
    .groupedBy { $0.index }
      .sorted(by: { $0.key < $1.key })

    return ScrollViewReader { proxy in
      ZStack {
        groupedContactsList(contactGroups)
        if showLoading {
          ActivityIndicatorView(color: .gray)
            .padding()
        }
      }
      .overlay(
        SectionIndexTitles(proxy: proxy, titles: contactGroups.map { $0.key })
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.trailing, 2)
      )
    }
  }

  func groupedContactsList(_ group: [(key: String, value: [Contact])]) -> some View {
    List {
      header()
      ForEach(group, id: \.key) { category, contacts in
        Section(header: SectionHeaderTitle(title: category)) {
          ForEach(contacts) { contact in
            ImageTitleRow(
              imageUrl: URL(string: contact.avatar),
              imagePlaceholder: .init(
                image: .avatarPlaceholder,
                size: .init(width: 40, height: 40),
                foregroundColor: .app_bg
              ),
              imageSize: .init(width: 40, height: 40),
              imageCornerRadius: 4,
              title: contact.name,
              destination: { selectionDestination(contact) },
              showRightArrow: false
            )
          }
          .listRowBackground(Color.app_white)
          .frame(height: 44)
        }
      }
    }
    .listStyle(.plain)
    .environment(\.defaultMinListHeaderHeight, 20)
  }
}

// MARK: - Helper Types
private extension ContactsList {

  // MARK: - SectionIndexTitles

  struct SectionIndexTitles: View {

    let proxy: ScrollViewProxy
    let titles: [String]

    @GestureState
    private var dragLocation: CGPoint = .zero

    @State
    private var selectedTitle: String?

    @State
    private var showSelectionBubble = false

    var body: some View {
      VStack {
        ForEach(titles, id: \.self) { title in
          let isSelected = isSelectedIndex(withTitle: title)
          HStack {
            Spacer()

            SectionIndexSelectionBubble {
              Text(title)
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .bold))
            }
            .frame(width: 70, height: 50)
            .opacity(selectionBubbleOpacityForIndex(withTitle: title))
            .animation(showSelectionBubble ? .none : .easeOut, value: showSelectionBubble)

            SectionIndexTitle(
              title: title,
              isSelected: isSelected,
              onTap: {
                scrollToTitle(title)

                showSelectionBubble = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                  showSelectionBubble = false
                }
              }
            )
            .background(dragObserver(title: title))
          }
          .frame(height: 16)
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
          .updating($dragLocation) { value, state, _ in
            state = value.location
          }
          .onEnded({ _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
              showSelectionBubble = false
            }
          })
      )
    }

    private func isSelectedIndex(withTitle title: String) -> Bool? {
      selectedTitle == nil ? nil : selectedTitle! == title
    }

    private func selectionBubbleOpacityForIndex(withTitle title: String) -> Double {
      let isSelected = isSelectedIndex(withTitle: title)
      return isSelected == nil ? 0 : (isSelected! && showSelectionBubble) ? 1 : 0
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
          showSelectionBubble = true
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

  // MARK: - SectionIndexSelectionBubble

  struct SectionIndexSelectionBubble<Title: View>: View {
    let title: () -> Title

    var body: some View {
      GeometryReader { geo in

        let startDegree: CGFloat = 45
        let startRadius: CGFloat = startDegree * .pi / 180
        let height = geo.size.height
        let radius = height * 0.5

        let deltaX = cos(startRadius) * radius
        let deltaY = sin(startRadius) * radius

        HStack(spacing: -(radius - deltaX)) {
          ZStack {
            Path { path in
              path.addArc(
                center: .init(x: radius, y: radius),
                radius: radius,
                startAngle: Angle(degrees: 360 - Double(startDegree)),
                endAngle: Angle(degrees: Double(startDegree)),
                clockwise: true
              )
            }

            title()
          }
          .frame(width: geo.size.height, height: geo.size.height)

          Path { path in
            let topPoint = CGPoint(x: 0, y: radius - deltaY)
            let bottomPoint = CGPoint(x: 0, y: radius + deltaY)

            let deltaX2 = tan(startRadius) * deltaY
            let leftPoint = CGPoint(x: deltaX2, y: radius)

            path.move(to: topPoint)
            path.addLine(to: leftPoint)
            path.addLine(to: bottomPoint)
          }
          .frame(height: geo.size.height)

          Spacer()
        }
        .foregroundColor(.hex("#C9C9C9"))
      }
    }
  }
}

struct ContactsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactsList(
      contacts: .loaded([User.template, User.template2]),
      searchText: "",
      loadContacts: {},
      header: { EmptyView() },
      selectionDestination: { c in Text(c.name) }
    )
  }
}
