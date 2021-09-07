extension Message {
  func setStatus(_ status: Status) -> Message {
    Message(
      id: id,
      text: text,
      image: image,
      videoUrl: videoUrl,
      sender: sender,
      createTime: createTime,
      status: status
    )
  }

  func setLocalImageStatus(_ imageStatus: Image.LocalImage.Status) -> Message {
    Message(
      id: id,
      text: text,
      image: .init(
        urlImage: image?.urlImage,
        localImage: image?.localImage?.setSatus(imageStatus)
      ),
      videoUrl: videoUrl,
      sender: sender,
      createTime: createTime,
      status: status
    )
  }

  func setImage(urlImage: Image.URLImage) -> Message {
    Message(
      id: id,
      text: text,
      image: .init(urlImage: urlImage, localImage: image?.localImage),
      videoUrl: videoUrl,
      sender: sender,
      createTime: createTime,
      status: status
    )
  }
}
