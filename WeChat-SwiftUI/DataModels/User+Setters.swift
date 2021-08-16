extension User {
  func setName(_ name: String) -> User {
    User(
      id: id,
      avatar: avatar,
      name: name,
      wechatId: wechatId,
      gender: gender,
      region: region,
      whatsUp: whatsUp
    )
  }

  func setAvatar(_ avatar: String) -> User {
    User(
      id: id,
      avatar: avatar,
      name: name,
      wechatId: wechatId,
      gender: gender,
      region: region,
      whatsUp: whatsUp
    )
  }

  func setGender(_ gender: Gender) -> User {
    User(
      id: id,
      avatar: avatar,
      name: name,
      wechatId: wechatId,
      gender: gender,
      region: region,
      whatsUp: whatsUp
    )
  }

  func setWhatsUp(_ whatsUp: String) -> User {
    User(
      id: id,
      avatar: avatar,
      name: name,
      wechatId: wechatId,
      gender: gender,
      region: region,
      whatsUp: whatsUp
    )
  }
}
