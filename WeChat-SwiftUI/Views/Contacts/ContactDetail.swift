import SwiftUI

struct ContactDetail: View {
  let contact: User

  var body: some View {
    Text(contact.name)
  }
}

struct ContactDetail_Previews: PreviewProvider {
  static var previews: some View {
    ContactDetail(contact: .template)
  }
}
