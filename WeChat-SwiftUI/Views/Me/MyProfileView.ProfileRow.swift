import SwiftUI

extension MyProfileView {
  struct ProfileRow: View {

    let row: MyProfileRowType
    let user: User

    @State
    private var showingSheet = false

    var body: some View {
      let view: AnyView
      let presentation = row.destinationPresentation(user: user)

      switch presentation.style {
      case .modal:
        view = HStack {
          rowTitle
          Spacer()
          rowDetail
          rightArrow
        }
        .onTapGesture {
          showingSheet = true
        }
        .fullScreenCover(isPresented: $showingSheet, content: { presentation.destination })
        .asAnyView()

      case .push:
        view = NavigationLink(destination: presentation.destination) {
          HStack {
            rowTitle
            Spacer()
            rowDetail
          }
        }
        .asAnyView()
      }

      return view
        .padding(.vertical, Constant.rowVerticalPadding)
    }

    private var rowTitle: some View {
      Text(row.title)
        .font(.system(size: Constant.titleFontSize))
        .foregroundColor(.text_primary)
    }

    private var rowDetail: some View {
      row.detailView(user: user)
    }

    private var rightArrow: some View {
      Image(systemName: "chevron.right")
        .font(.system(size: Constant.rightArrowFontSize, weight: .medium))
        .foregroundColor(.text_info_200)
    }
  }
}

private extension MyProfileView.ProfileRow {
  enum Constant {
    static let titleFontSize: CGFloat = 16
    static let rightArrowFontSize: CGFloat = 14
    static let rowVerticalPadding: CGFloat = 8
  }
}
