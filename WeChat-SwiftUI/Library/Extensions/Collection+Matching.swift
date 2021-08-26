extension Collection where Element: Identifiable {
  func index(matching element: Element) -> Self.Index? {
    firstIndex(where: { $0.id == element.id })
  }

  func element(matching element: Element) -> Element {
    first(where: { $0.id == element.id }) ?? element
  }
}
