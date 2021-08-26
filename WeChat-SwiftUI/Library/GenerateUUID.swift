import Foundation

func generateUUID() -> String {
  UUID().uuidString.lowercased()
}
