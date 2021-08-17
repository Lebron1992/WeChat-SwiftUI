import SwiftUI

struct ErrorView: View {
  let error: Error
  let retryAction: () -> Void

  var body: some View {
    VStack {
      Text(Strings.general_an_error_occured())
        .font(.title)
      Text((error as? APIError)?.localizedDescription ?? error.localizedDescription)
        .font(.callout)
        .multilineTextAlignment(.center)
        .padding(.bottom, 40)
        .padding()
      Button(action: retryAction, label: { Text(Strings.general_retry()).bold() })
    }
  }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorView(
      error: NSError(
        domain: "",
        code: 0,
        userInfo: [
          NSLocalizedDescriptionKey: Strings.general_something_went_wrong()]
      ),
      retryAction: { }
    )
  }
}
#endif
