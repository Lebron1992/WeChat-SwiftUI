extension OfficialAccount {
  static let template1: OfficialAccount! = tryDecode(
    """
    {
    "id": "cf73ed17-20b5-4254-b67c-c6539acb4d81",
    "avatar": "https://raw.githubusercontent.com/Lebron1992/WeChat-SwiftUI-Database/main/images/guangdongdianxin.jpeg",
    "name": "广东电信",
    "pinyin": "guangdongdianxin"
    }
    """
  )

  static let template2: OfficialAccount! = tryDecode(
    """
    {
    "id": "93209b2a-f4d2-43b9-b173-228c417b1a8e",
    "avatar": "https://raw.githubusercontent.com/Lebron1992/WeChat-SwiftUI-Database/main/images/kejimeixue.jpeg",
    "name": "科技美学",
    "pinyin": "kejimeixue"
    }
    """
  )
}
