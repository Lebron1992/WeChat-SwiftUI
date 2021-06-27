import SwiftUI
import SwiftUIRedux

struct ContactCategoriesList: ConnectedView {
  struct Props {
    let categories: [ContactCategory]
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(categories: state.contactsState.categories)
  }

  func body(props: Props) -> some View {
    ForEach(props.categories, id: \.title) { category in
      ZStack(alignment: .leading) {
        NavigationLink(destination: destination(for: category)) {
          EmptyView()
        }
        .opacity(0.0) // 为了隐藏 NavigationLink 右边的箭头
        ContactCategoryRow(category: category)
      }
    }
    .listRowBackground(Color.app_white)
  }
}

// MARK: - Helper Methods
private extension ContactCategoriesList {
  func destination(for category: ContactCategory) -> AnyView {
    switch category {
    case .officalAccount:
      return AnyView(ContactOfficialAccountsList())
    default:
      return AnyView(Text(category.title))
    }
  }
}

struct ContactRowCategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        ContactCategoriesList()
    }
}
