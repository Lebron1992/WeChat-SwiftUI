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
}
