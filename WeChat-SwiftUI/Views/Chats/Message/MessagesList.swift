import SwiftUI
import ComposableArchitecture

struct MessagesList: View {

  var body: some View {
    List {
      ForEach(messages, id: \.self) {
        MessageRow(store: store, message: $0)
          .listRowInsets(Constant.listRowInset)
          .listRowSeparator(.hidden)
      }
    }
    .background(.app_bg)
    .listStyle(.plain)
  }

  let store: Store<AppState, AppAction>
  let messages: [Message]
}

private extension MessagesList {
  enum Constant {
    static let listRowInset: EdgeInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
  }
}

struct MessagesList_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment.current
    )
    MessagesList(store: store, messages: [Message.textTemplate1, Message.textTemplate2])
  }
}
