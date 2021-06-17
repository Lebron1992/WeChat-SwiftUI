extension User {
  static let template: User! = tryDecode(
    """
    {
    "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
    "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
    "name": "Ja Morant",
    "wechat_id": "ja_morant",
    "gender": "male",
    "region": "USA",
    "whats_up": "Hello, I'm Ja Morant!"
    }
    """
  )
}
