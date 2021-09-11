import SwiftUI
import SwiftUIRedux

/* TODO:
--- 因为暂时无法改变 header 的高度，所以 SectionHeader 使用 cell 代替
 */

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
      ForEach(props.discoverSections, id: \.self) {
        discoverSection(section: $0)
      }
    }
    .listStyle(.plain)
    .environment(\.defaultMinListRowHeight, 10)
  }
}

private extension DiscoverList {

  func discoverSection(section: DiscoverSection) -> some View {

    let header = section.isFirstSection ? EmptyView().asAnyView() : SectionHeaderBackground().asAnyView()

    return Group {
      header
      Section {
        ForEach(section.items, id: \.self) {
          discoverItemRow(item: $0)
            .listRowBackground(Color.app_white)
        }
      }
    }
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
