import SwiftUI
import ComposableArchitecture
import URLImage

struct MyProfilePhotoPreview: View {

  var body: some View {
    WithViewStore(store.wrappedValue) { viewStore in
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
        .onChange(of: viewModel.photoUploadStatus) { status in
          Task { await handlePhotoUploadStatusChange(status, viewStore: viewStore) }
        }
        .onChange(of: viewModel.userSelfUpdateStatus) {
          handleUserSelfUpdateStatusChange($0, viewStore: viewStore)
        }
        .onChange(of: pickedPhoto) { newImage in
          if let image = newImage {
            viewModel.uploadPhoto(image)
          }
        }
    }
  }

  let photoUrl: String?

  @EnvironmentObject
  private var store: StoreObservableObject<Void, AppAction>

  @State
  private var photoPicker: PhotoPickerType?

  @State
  private var pickedPhoto: UIImage?

  @State
  private var showLoading = false

  @StateObject
  private var viewModel = MyProfilePhotoPreviewViewModel()
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

  func handlePhotoUploadStatusChange(_ status: ValueUpdateStatus<URL>, viewStore: ViewStore<Void, AppAction>) async {
    switch status {
    case .updating:
      showLoading = true

    case .finished(let url):
      let newUser = AppEnvironment.current.currentUser!.setAvatar(url.absoluteString)
      await viewModel.updateUserSelf(newUser)
      showLoading = false

    case .failed(let error):
      viewStore.send(.system(.setErrorMessage(error.localizedDescription)))
      showLoading = false
    default:
      showLoading = false
    }
  }

  func handleUserSelfUpdateStatusChange(_ status: ValueUpdateStatus<User>, viewStore: ViewStore<Void, AppAction>) {
    switch status {
    case .updating:
      showLoading = true

    case .finished(let user):
      viewStore.send(.auth(.setSignedInUser(user)))
      showLoading = false

    case .failed(let error):
      viewStore.send(.system(.setErrorMessage(error.localizedDescription)))
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
    let store = Store(
      initialState: AppState(),
      reducer: appReducer
    )
      .stateless
    MyProfilePhotoPreview(photoUrl: User.template1.avatar)
      .environmentObject(StoreObservableObject(store: store))
  }
}
