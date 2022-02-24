import SwiftUI
import SwiftUIRedux

struct DiscoverList: ConnectedView {
  struct Props {
    let discoverSections: [DiscoverSection]
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      discoverSections: state.discoverState.discoverSections
    )
  }

  func body(props: Props) -> some View {
    List {
      ForEach(props.discoverSections, id: \.self) { section in
        if section.isFirstSection == false {
          SectionHeaderBackground()
        }
        discoverSection(section: section)
      }
    }
    .listStyle(.plain)
    .background(.app_bg)
    .environment(\.defaultMinListRowHeight, 10)
  }
}

private extension DiscoverList {

  @ViewBuilder
  func discoverSection(section: DiscoverSection) -> some View {
    Section {
      ForEach(section.items, id: \.self) {
        discoverItemRow(item: $0)
          .listRowBackground(Color.app_white)
      }
    }
    .listSectionSeparator(.hidden)
  }

  func discoverItemRow(item: DiscoverItem) -> some View {
    ImageTitleRow(
      image: item.iconImage,
      imageColor: item.iconForegroundColor,
      imageSize: Constant.itemImageSize,
      title: item.title,
      destination: { Text(item.title) }
    )
  }
}

private extension DiscoverList {
  enum Constant {
    static let itemImageSize: CGSize = .init(width: 24, height: 24)
  }
}

struct DiscoverList_Previews: PreviewProvider {
  static var previews: some View {
    DiscoverList()
  }
}
