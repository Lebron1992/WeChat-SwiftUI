import SwiftUI
import SwiftUIRedux

/* TODO:
--- section header 吸到顶部时，背景色改为白色，title 颜色改为 highlighted
--- 滚动列表时，右边的索引切换到对应的 section
*/

struct ContactsList<Contact: ContactType, Header: View, Destination: View>: View {

  @ViewBuilder
  var body: some View {
    switch contacts {
    case .notRequested:
      Text("").onAppear(perform: loadContacts)

    case let .isLoading(last):
      loadingView(contacts: last, searchText: searchText)

    case let .loaded(contacts):
      loadedView(contacts: contacts, searchText: searchText, showLoading: false)

    case let .failed(error):
      ErrorView(error: error, retryAction: loadContacts)
    }
  }

  let contacts: Loadable<[Contact]>
  let searchText: String
  let loadContacts: () -> Void
  let header: () -> Header?
  let selectionDestination: (Contact) -> Destination?
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
          .listSectionSeparator(.hidden)
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

struct ContactsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactsList(
      contacts: .loaded([User.template1, User.template2]),
      searchText: "",
      loadContacts: { },
      header: { EmptyView() },
      selectionDestination: { c in Text(c.name) }
    )
  }
}
