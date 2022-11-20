import SwiftUI

extension ContactsList {
  struct SectionIndexTitles: View {

    var body: some View {
      VStack {
        ForEach(titles, id: \.self) { title in
          let isSelected = isSelectedIndex(withTitle: title)
          HStack {
            Spacer()

            SectionIndexSelectionBubble {
              Text(title)
                .foregroundColor(.white)
                .font(.system(size: ContactsListIndexConstant.bubbleTitleFontSize, weight: .bold))
            }
            .frame(
              width: ContactsListIndexConstant.bubbleSize.width,
              height: ContactsListIndexConstant.bubbleSize.height
            )
            .opacity(selectionBubbleOpacityForIndex(withTitle: title))
            .animation(showSelectionBubble ? .none : .easeOut, value: showSelectionBubble)

            SectionIndexTitle(
              title: title,
              isSelected: isSelected,
              onTap: {
                scrollToTitle(title)

                showSelectionBubble = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                  showSelectionBubble = false
                }
              }
            )
              .background(dragObserver(title: title))
          }
          .frame(height: ContactsListIndexConstant.indexTitleSize.height)
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
          .updating($dragLocation) { value, state, _ in
            state = value.location
          }
          .onEnded({ _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
              showSelectionBubble = false
            }
          })
      )
    }

    let scrollView: ScrollViewProxy
    let titles: [String]

    @GestureState
    private var dragLocation: CGPoint = .zero

    @State
    private var selectedTitle: String?

    @State
    private var showSelectionBubble = false

    // MARK: - Helper Methods

    private func isSelectedIndex(withTitle title: String) -> Bool? {
      selectedTitle == nil ? nil : selectedTitle! == title
    }

    private func selectionBubbleOpacityForIndex(withTitle title: String) -> Double {
      let isSelected = isSelectedIndex(withTitle: title)
      return isSelected == nil ? 0 : (isSelected! && showSelectionBubble) ? 1 : 0
    }

    private func dragObserver(title: String) -> some View {
      GeometryReader { geometry in
        dragObserver(geometry: geometry, title: title)
      }
    }

    private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
      if geometry.frame(in: .global).contains(dragLocation) {
        DispatchQueue.main.async {
          scrollToTitle(title)
          showSelectionBubble = true
        }
      }
      return Rectangle().fill(Color.clear)
    }

    private func scrollToTitle(_ title: String) {
      guard selectedTitle != title else {
        return
      }
      scrollView.scrollTo(title, anchor: .top)
      selectedTitle = title
      Haptics.impact(.light)
    }
  }
}

extension ContactsList {
  struct SectionIndexTitle: View {

    let title: String
    let isSelected: Bool?
    let onTap: () -> Void

    var body: some View {
      Text(title)
        .font(.system(size: ContactsListIndexConstant.indexTitleFontSize, weight: .semibold))
        .foregroundColor(foregroundColor)
        .frame(
          width: ContactsListIndexConstant.indexTitleSize.width,
          height: ContactsListIndexConstant.indexTitleSize.height
        )
        .background(background)
        .cornerRadius(cornerRadius)
        .contentShape(Rectangle()) // 解决问题：背景色为透明时，手势无效
        .onTapGesture(perform: onTap)
    }

    private var foregroundColor: Color {
      isSelected == nil ?
        .text_info_500 :
      isSelected! ? .white : .text_info_500
    }

    private var background: Color {
      isSelected == nil ?
        .clear :
      isSelected! ? .highlighted : .clear
    }

    private var cornerRadius: CGFloat {
      isSelected == nil ?
      0 :
      isSelected! ? ContactsListIndexConstant.indexTitleBackgroundCornerRaidus : 0
    }
  }
}

extension ContactsList {
  struct SectionIndexSelectionBubble<Title: View>: View {
    let title: () -> Title

    var body: some View {
      GeometryReader { geo in

        let startDegree: CGFloat = 45
        let startRadius: CGFloat = startDegree * .pi / 180
        let height = geo.size.height
        let radius = height * 0.5

        let deltaX = cos(startRadius) * radius
        let deltaY = sin(startRadius) * radius

        HStack(spacing: -(radius - deltaX)) {
          ZStack {
            Path { path in
              path.addArc(
                center: .init(x: radius, y: radius),
                radius: radius,
                startAngle: Angle(degrees: 360 - Double(startDegree)),
                endAngle: Angle(degrees: Double(startDegree)),
                clockwise: true
              )
            }

            title()
          }
          .frame(width: geo.size.height, height: geo.size.height)

          Path { path in
            let topPoint = CGPoint(x: 0, y: radius - deltaY)
            let bottomPoint = CGPoint(x: 0, y: radius + deltaY)

            let deltaX2 = tan(startRadius) * deltaY
            let leftPoint = CGPoint(x: deltaX2, y: radius)

            path.move(to: topPoint)
            path.addLine(to: leftPoint)
            path.addLine(to: bottomPoint)
          }
          .frame(height: geo.size.height)

          Spacer()
        }
        .foregroundColor(.hex("#C9C9C9"))
      }
    }
  }
}

private enum ContactsListIndexConstant {
  static let bubbleTitleFontSize: CGFloat = 25
  static let bubbleSize: CGSize = .init(width: 70, height: 50)
  static let indexTitleSize: CGSize = .init(width: 16, height: 16)
  static let indexTitleFontSize: CGFloat = 11
  static let indexTitleBackgroundCornerRaidus: CGFloat = 8
}
