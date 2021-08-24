import Foundation

enum PhotoPickerType: Identifiable {
  case camera
  case library

  var id: PhotoPickerType { self }
}
