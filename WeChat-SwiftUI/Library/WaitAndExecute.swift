import Foundation

func wait(interval: TimeInterval = 1, execute block: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: block)
}
