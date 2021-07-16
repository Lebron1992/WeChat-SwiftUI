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
        DiscoverSection(section: $0)
      }
    }
    .background(.app_bg)
    .listStyle(.plain)
    .environment(\.defaultMinListRowHeight, 10)
  }
}

private extension DiscoverList {

  func DiscoverSection(section: DiscoverSection) -> some View {

    let header = section.isFirstSection ? AnyView(EmptyView()) : AnyView(SectionHeaderBackground())

    return Group {
      header
      Section {
        ForEach(section.items, id: \.self) {
          DiscoverItemRow(item: $0)
            .listRowBackground(Color.app_white)
        }
      }
    }
  }

  func DiscoverItemRow(item: DiscoverItem) -> some View {
    ImageTitleRow(
      image: item.iconImage,
      title: item.title,
      destination: { Text(item.title) }
    )
  }
}

struct DiscoverList_Previews: PreviewProvider {
  static var previews: some View {
    DiscoverList()
  }
}
