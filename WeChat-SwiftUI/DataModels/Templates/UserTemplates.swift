extension User {
  static let template1: User! = tryDecode(
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

  static let template2: User! = tryDecode(
    """
    {
    "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
    "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
    "name": "LeBron James",
    "wechat_id": "lebron_james",
    "gender": "male",
    "region": "USA",
    "whats_up": "Hello, I'm LeBron James!"
    }
    """
  )
}
