import SwiftUI
import ComposableArchitecture

struct ContactCategoriesList: View {

  var body: some View {
    WithViewStore(store.wrappedValue, observe: { $0.contactsState }) { viewStore in
      ForEach(viewStore.categories, id: \.title) { category in
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

  func destination(for category: ContactCategory, viewStore: ViewStore<ContactsState, AppAction>) -> AnyView {
    switch category {
    case .officalAccounts:
      return ContactOfficialAccountsList(
        accounts: viewStore.officialAccounts,
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
        reducer: appReducer
      )
      VStack(alignment: .leading) {
        ContactCategoriesList()
          .environmentObject(StoreObservableObject(store: store))
      }
    }
}
