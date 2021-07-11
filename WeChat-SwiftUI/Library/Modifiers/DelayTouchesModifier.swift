import SwiftUI

extension View {
  func delayTouches(for duration: TimeInterval = 0.25, onTap action: @escaping () -> Void = {}) -> some View {
    modifier(DelayTouches(duration: duration, action: action))
  }
}

// Refer to:
// https://www.hackingwithswift.com/forums/swiftui/a-guide-to-delaying-gestures-in-scrollview/6005

private struct DelayTouches: ViewModifier {
  @State
  private var disabled = false

  @State
  private var touchDownDate: Date?

  var duration: TimeInterval
  var action: () -> Void

  func body(content: Content) -> some View {
    Button(action: action) {
      content
    }
    .buttonStyle(DelayTouchesButtonStyle(duration: duration, disabled: $disabled, touchDownDate: $touchDownDate))
    .disabled(disabled)
  }
}

private struct DelayTouchesButtonStyle: ButtonStyle {

  var duration: TimeInterval

  @Binding
  var disabled: Bool

  @Binding
  var touchDownDate: Date?

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .onChange(of: configuration.isPressed, perform: handleIsPressed)
  }

  private func handleIsPressed(isPressed: Bool) {
    if isPressed {
      let date = Date()
      touchDownDate = date

      DispatchQueue.main.asyncAfter(deadline: .now() + max(duration, 0)) {
        if date == touchDownDate {
          disabled = true

          DispatchQueue.main.async {
            disabled = false
          }
        }
      }
    } else {
      touchDownDate = nil
      disabled = false
    }
  }
}
