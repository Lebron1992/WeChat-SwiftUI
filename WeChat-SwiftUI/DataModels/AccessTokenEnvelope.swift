struct AccessTokenEnvelope {
  let accessToken: String
  let user: User

  init(accessToken: String, user: User) {
    self.accessToken = accessToken
    self.user = user
  }
}
