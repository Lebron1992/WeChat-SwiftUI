// swiftlint:disable line_length
extension Message {
  static let textTemplate1: Message! = tryDecode(
    """
    {
    "id": "d6a696da-2c7a-4d27-87e3-6f63fd3e597f",
    "text": "hello world",
    "sender": {
      "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
      "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
      "name": "Ja Morant"
    },
    "createTime": "2021-07-14T09:54:22Z",
    "status": "sent"
    }
    """
  )

  static let textTemplate2: Message! = tryDecode(
    """
    {
    "id": "d05b35fc-9d3c-4478-a526-31127d8fee41",
    "text": "SwiftUI helps you build great-looking apps across all Apple platforms with the power of Swift — and as little code as possible.",
    "sender": {
      "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
      "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
      "name": "LeBron James",
    },
    "createTime": "2021-07-14T09:54:23Z",
    "status": "sent"
    }
    """
  )

  static let urlImageTemplate = Message(image: .urlTemplate)
  static let uiImageTemplateIdle = Message(image: .uiImageTemplateIdle)
  static let uiImageTemplateUploaded = Message(image: .uiImageTemplateUploaded)
  static let uiImageTemplateError = Message(image: .uiImageTemplateError)

  static let videoTemplate3: Message! = tryDecode(
    """
    {
    "id": "9e64ffee-2ac7-48c5-9569-09e763055d7d",
    "videoUrl": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.mp4",
    "sender": {
      "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
      "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
      "name": "LeBron James",
    },
    "createTime": "2021-07-14T09:54:42Z",
    "status": "sent"
    }
    """
  )
}
