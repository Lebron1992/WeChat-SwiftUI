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
      .map { ContactsGroup(startsWith: $0.key, contacts: $0.value) }

    return ZStack {
      List {
        ForEach(contactGroups) { group in
          Section(header: SectionHeader(title: group.startsWith)) {
            ForEach(group.contacts) { contact in
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
      if showLoading {
        ActivityIndicatorView(color: .gray)
          .padding()
      }
    }
  }
}

// MARK: - Helper Types
private extension ContactsList {
  struct ContactsGroup: Identifiable {
    let startsWith: String
    let contacts: [User]

    var id: String {
      startsWith
    }
  }
}

private extension ContactsList {
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
}

struct ContactsList_Previews: PreviewProvider {
  static var previews: some View {
    ContactsList()
  }
}
