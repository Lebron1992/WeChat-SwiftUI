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
      return Text("").onAppear(perform: loadContacts).asAnyView()

    case let .isLoading(last, _):
      return loadingView(contacts: last, searchText: searchText).asAnyView()

    case let .loaded(contacts):
      return loadedView(contacts: contacts, searchText: searchText, showLoading: false).asAnyView()

    case let .failed(error):
      return ErrorView(error: error, retryAction: loadContacts).asAnyView()
    }
  }
}

private extension ContactsList {

  @ViewBuilder
  func loadingView(contacts previouslyLoaded: [Contact]?, searchText: String) -> some View {
    if let result = previouslyLoaded {
      loadedView(contacts: result, searchText: searchText, showLoading: true)
    } else {
      ActivityIndicator().padding()
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

    return ScrollViewReader { scrollView in
      ZStack {
        groupedContactsList(contactGroups)
        if showLoading {
          ActivityIndicator().padding()
        }
      }
      .overlay(
        SectionIndexTitles(scrollView: scrollView, titles: contactGroups.map { $0.key })
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
              imagePlaceholder: .avatarPlaceholder,
              imageSize: ContactsListConstant.contactAvatarSize,
              imageCornerRadius: ContactsListConstant.contactAvatarCornerRadius,
              title: contact.name,
              showRightArrow: false,
              destination: { selectionDestination(contact) }
            )
          }
          .listRowBackground(Color.app_white)
          .frame(height: ContactsListConstant.contactRowHeight)
        }
      }
    }
    .listStyle(.plain)
    .environment(\.defaultMinListHeaderHeight, 20)
  }
}

private enum ContactsListConstant {
  static let contactAvatarSize: CGSize = .init(width: 40, height: 40)
  static let contactAvatarCornerRadius: CGFloat = 4
  static let contactRowHeight: CGFloat = 44
}

// MARK: - Helper Types

struct ContactsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactsList(
      contacts: .loaded([User.template, User.template2]),
      searchText: "",
      loadContacts: { },
      header: { EmptyView() },
      selectionDestination: { c in Text(c.name) }
    )
  }
}
