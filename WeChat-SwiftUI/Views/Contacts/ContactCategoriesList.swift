import SwiftUI
import ComposableArchitecture

struct ContactCategoriesList: View {

  var body: some View {
    WithViewStore(store.wrappedValue) { viewStore in
      ForEach(viewStore.contactsState.categories, id: \.title) { category in
        NavigationRow(destination: destination(for: category, viewStore: viewStore)) {
          ContactCategoryRow(category: category)
        }
      }
      .listRowBackground(Color.app_white)
    }
  }

  @EnvironmentObject
  private var store: StoreObservableObject<AppState, AppAction>
}

private extension ContactCategoriesList {

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
}

struct ContactRowCategoriesList_Previews: PreviewProvider {
    static var previews: some View {
      let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment.current
      )
      VStack(alignment: .leading) {
        ContactCategoriesList()
          .environmentObject(StoreObservableObject(store: store))
      }
    }
}
