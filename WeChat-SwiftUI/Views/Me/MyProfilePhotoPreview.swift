import SwiftUI
import URLImage

struct MyProfilePhotoPreview: View {
  let photoUrl: String?

  @StateObject
  private var viewModel = MyProfilePhotoPreviewViewModel()

  @State
  private var showLoading = false

  var body: some View {
    avatar
      .navigationBarItems(trailing: moreButton)
      .sheet(item: $photoPicker) { pickerType in
        switch pickerType {
        case .camera: ImagePicker(sourceType: .camera) { handlePickedImage($0) }
        case .library: ImagePicker(sourceType: .photoLibrary) { handlePickedImage($0) }
        }
      }
      .showLoading(showLoading)
      .onChange(of: pickedPhoto) { newImage in
        if let image = newImage {
          viewModel.uploadPhoto(image)
        }
      }
      .onChange(of: viewModel.photoUploadStatus, perform: handlePhotoUploadStatusChange(_:))
      .onChange(of: viewModel.userSelfUpdateStatus, perform: handleUserSelfUpdateStatusChange(_:))
  }

  @ViewBuilder
  private var avatar: some View {
    if let url = URL(string: photoUrl ?? "") {
      URLImage(
        url,
        empty: { avatarPlaceholder },
        inProgress: { _ in avatarPlaceholder },
        failure: { _, _ in avatarPlaceholder },
        content: { $0.resize(.fit) }
      )
    } else {
      avatarPlaceholder
    }
  }

  private var avatarPlaceholder: some View {
    let image: Image

    if viewModel.isUserSelfUpdated, let pickedImage = pickedPhoto {
      image = Image(uiImage: pickedImage)
    } else {
      image = .avatarPlaceholder
    }

    return image
      .resize(.fit)
      .foregroundColor(.app_bg)
  }

  private func handlePhotoUploadStatusChange(_ status: ValueUpdateStatus<URL>) {
    switch status {
    case .updating:
      showLoading = true

    case .finished(let url):
      let newUser = AppEnvironment.current.currentUser!.setAvatar(url.absoluteString)
      viewModel.updateUserSelf(newUser)
      showLoading = false

    case .failed(let error):
      setErrorMessage(error.localizedDescription)
      showLoading = false
    default:
      showLoading = false
    }
  }

  private func handleUserSelfUpdateStatusChange(_ status: ValueUpdateStatus<User>) {
    switch status {
    case .updating:
      showLoading = true

    case .finished(let user):
      updateSignedInUser(user)
      showLoading = false

    case .failed(let error):
      setErrorMessage(error.localizedDescription)
      showLoading = false
    default:
      showLoading = false
    }
  }

  // MARK: - More Menu

  private var moreButton: some View {
    Button {
      // TODO: Open library for now
      photoPicker = .library
    } label: {
      Image(systemName: "ellipsis")
    }
  }

  // MARK: - Pick Photo

  @State
  private var photoPicker: PhotoPickerType?

  @State
  private var pickedPhoto: UIImage?

  private enum PhotoPickerType: Identifiable {
    case camera
    case library
    var id: PhotoPickerType { self }
  }

  private func handlePickedImage(_ image: UIImage?) {
    pickedPhoto = image
    photoPicker = nil
  }
}

struct MyProfilePhotoPreview_Previews: PreviewProvider {
  static var previews: some View {
    MyProfilePhotoPreview(photoUrl: nil)
  }
}
