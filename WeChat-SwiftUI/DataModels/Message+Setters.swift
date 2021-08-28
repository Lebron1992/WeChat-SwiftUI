extension Message {
  func setStatus(_ status: Status) -> Message {
    Message(
      id: id,
      text: text,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      sender: sender,
      createTime: createTime,
      status: status
    )
  }
}
