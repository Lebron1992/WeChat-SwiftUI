import SwiftUI

extension MyProfileView {
  struct ProfileRow: View {

    let row: MyProfileRowType
    let user: User

    @State
    private var showingSheet = false

    var body: some View {
      let destination = row.navigateDestination(with: user)
      Group {
        switch destination.style {
        case .modal:
          modalContent(destination: destination)
        case .push:
          pushContent(destination: destination)
        }
      }
      .padding(.vertical, Constant.rowVerticalPadding)
    }

    private func modalContent(destination: MyProfileRowType.Destination) -> some View {
      HStack {
        rowTitle
        Spacer()
        rowDetail
        rightArrow
      }
      .onTapGesture {
        showingSheet = true
      }
      .fullScreenCover(isPresented: $showingSheet, content: { destination.content })
    }

    private func pushContent(destination: MyProfileRowType.Destination) -> some View {
      NavigationLink(destination: destination.content) {
        HStack {
          rowTitle
          Spacer()
          rowDetail
        }
      }
    }

    private var rowTitle: some View {
      Text(row.title)
        .font(.system(size: Constant.titleFontSize))
        .foregroundColor(.text_primary)
    }

    private var rowDetail: some View {
      row.detailView(with: user)
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
