import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

  static var isCameraAvailable: Bool {
    UIImagePickerController.isSourceTypeAvailable(.camera)
  }

  static var isPhotoLibraryAvailable: Bool {
    UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
  }

  private let sourceType: UIImagePickerController.SourceType
  private let allowsEditing: Bool
  private let handlePickedImage: (UIImage?) -> Void

  init(
    sourceType: UIImagePickerController.SourceType,
    allowsEditing: Bool = true,
    handlePickedImage: @escaping (UIImage?) -> Void
  ) {
    self.sourceType = sourceType
    self.allowsEditing = allowsEditing
    self.handlePickedImage = handlePickedImage
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = sourceType
    picker.allowsEditing = allowsEditing
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

  func makeCoordinator() -> Coordinator {
    Coordinator(handlePickedImage: handlePickedImage)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let handlePickedImage: (UIImage?) -> Void

    init(handlePickedImage: @escaping (UIImage?) -> Void) {
      self.handlePickedImage = handlePickedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      handlePickedImage(nil)
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      handlePickedImage((info[.editedImage] ?? info[.originalImage]) as? UIImage)
    }
  }
}
