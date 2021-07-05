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
      ForEach(props.discoverSections, id: \.self) {
        DiscoverSection(section: $0)
      }
    }
    .environment(\.defaultMinListHeaderHeight, 10)
  }
}

private extension DiscoverList {

  func DiscoverSection(section: DiscoverSection) -> some View {
    let header = section.isFirstSection ? AnyView(EmptyView()) : AnyView(SectionHeader())

    return Section(header: header) {
      ForEach(section.items, id: \.self) {
        DiscoverItemRow(item: $0)
      }
      .listRowBackground(Color.app_white)
    }
  }

  func SectionHeader() -> some View {
    Color.app_bg
      .listRowInsets(.zero)
  }

  func DiscoverItemRow(item: DiscoverItem) -> some View {
    NavigationLink(
      destination: Text(item.title),
      label: {
        HStack {
          item.iconImage
            .frame(width: 24, height: 24)
          Text(item.title)
            .foregroundColor(.text_primary)
            .font(.system(size: 16))
        }
      })
      .frame(height: 44)
  }
}

struct DiscoverList_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverList()
    }
}
