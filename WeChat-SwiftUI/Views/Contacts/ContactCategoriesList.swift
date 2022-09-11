import SwiftUI
import ComposableArchitecture

struct ContactCategoriesList: View {
  var body: some View {
    WithViewStore(store) { viewStore in
      ForEach(viewStore.contactsState.categories, id: \.title) { category in
        NavigationRow(destination: destination(for: category, viewStore: viewStore)) {
          ContactCategoryRow(category: category)
        }
      }
      .listRowBackground(Color.app_white)
    }
  }

  func destination(for category: ContactCategory, viewStore: ViewStore<AppState, AppAction>) -> AnyView {
    switch category {
    case .officalAccounts:
      return ContactOfficialAccountsList(
        accounts: viewStore.contactsState.officialAccounts,
        loadAccounts: { viewStore.send(.contacts(.loadOfficialAccounts)) }
      ).asAnyView()
    default:
      return Text(category.title).asAnyView()
    }
  }

  let store: Store<AppState, AppAction>
}

struct ContactRowCategoriesList_Previews: PreviewProvider {
    static var previews: some View {
      let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment.current
      )
      VStack(alignment: .leading) {
        ContactCategoriesList(store: store)
      }
    }
}
