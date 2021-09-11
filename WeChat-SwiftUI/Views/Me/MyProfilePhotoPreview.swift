import SwiftUI
import URLImage

struct MyProfilePhotoPreview: View {
  let photoUrl: String?

  @State
  private var photoPicker: PhotoPickerType?

  @State
  private var pickedPhoto: UIImage?

  @State
  private var showLoading = false

  @StateObject
  private var viewModel = MyProfilePhotoPreviewViewModel()

  var body: some View {
    avatar
      .navigationBarItems(trailing: moreButton)
      .navigationTitle(Strings.me_my_profile_photo())
      .sheet(item: $photoPicker) { pickerType in
        switch pickerType {
        case .camera: ImagePicker(sourceType: .camera) { handlePickedImage($0) }
        case .library: ImagePicker(sourceType: .photoLibrary) { handlePickedImage($0) }
        }
      }
      .showLoading(showLoading)
      .onChange(of: viewModel.photoUploadStatus, perform: handlePhotoUploadStatusChange(_:))
      .onChange(of: viewModel.userSelfUpdateStatus, perform: handleUserSelfUpdateStatusChange(_:))
      .onChange(of: pickedPhoto) { newImage in
        if let image = newImage {
          viewModel.uploadPhoto(image)
        }
      }
  }
}

// MARK: - Views
private extension MyProfilePhotoPreview {

  @ViewBuilder
  var avatar: some View {
    URLPlaceholderImage(photoUrl, contentMode: .fit) {
      avatarPlaceholder
    }
  }

  var avatarPlaceholder: some View {
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

  var moreButton: some View {
    Button {
      // TODO: Open library for now
      photoPicker = .library
    } label: {
      Image(systemName: "ellipsis")
    }
  }
}

// MARK: - Helper Methods
private extension MyProfilePhotoPreview {

  func handlePhotoUploadStatusChange(_ status: ValueUpdateStatus<URL>) {
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

  func handleUserSelfUpdateStatusChange(_ status: ValueUpdateStatus<User>) {
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

  func handlePickedImage(_ image: UIImage?) {
    pickedPhoto = image
    photoPicker = nil
  }
}

struct MyProfilePhotoPreview_Previews: PreviewProvider {
  static var previews: some View {
    MyProfilePhotoPreview(photoUrl: nil)
  }
}
