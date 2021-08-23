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
      NavigationRow(destination: destination(for: category)) {
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
