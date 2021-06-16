//=======================================================================
//
// This file is computer generated from Localizable.strings. Do not edit.
//
//=======================================================================

// swiftlint:disable valid_docs
// swiftlint:disable line_length
public enum Strings {
  /**
   "Internal server error"

   - **en**: "Internal server error"
   - **zh**: "内部服务器错误"
  */
  public static func api_error_internal_server_error() -> String {
    return localizedString(
      key: "api.error.internal_server_error",
      defaultValue: "Internal server error",
      count: nil,
      substitutions: [:]
    )
  }
  /**
   "Invalid URL: %{url}"

   - **en**: "Invalid URL: %{url}"
   - **zh**: "无效的 URL：%{url}"
  */
  public static func api_error_invalid_url(url: String) -> String {
    return localizedString(
      key: "api.error.invalid_url",
      defaultValue: "Invalid URL: %{url}",
      count: nil,
      substitutions: ["url": url]
    )
  }
  /**
   "Unexpected response: %{response}"

   - **en**: "Unexpected response: %{response}"
   - **zh**: "出乎意料的响应：%{response}"
  */
  public static func api_error_unexpected_response(response: String) -> String {
    return localizedString(
      key: "api.error.unexpected_response",
      defaultValue: "Unexpected response: %{response}",
      count: nil,
      substitutions: ["response": response]
    )
  }
  /**
   "Chats"

   - **en**: "Chats"
   - **zh**: "聊天"
  */
  public static func tabbar_chats() -> String {
    return localizedString(
      key: "tabbar.chats",
      defaultValue: "Chats",
      count: nil,
      substitutions: [:]
    )
  }
  /**
   "Contacts"

   - **en**: "Contacts"
   - **zh**: "联系人"
  */
  public static func tabbar_contacts() -> String {
    return localizedString(
      key: "tabbar.contacts",
      defaultValue: "Contacts",
      count: nil,
      substitutions: [:]
    )
  }
  /**
   "Discover"

   - **en**: "Discover"
   - **zh**: "发现"
  */
  public static func tabbar_discover() -> String {
    return localizedString(
      key: "tabbar.discover",
      defaultValue: "Discover",
      count: nil,
      substitutions: [:]
    )
  }
  /**
   "Me"

   - **en**: "Me"
   - **zh**: "我"
  */
  public static func tabbar_me() -> String {
    return localizedString(
      key: "tabbar.me",
      defaultValue: "Me",
      count: nil,
      substitutions: [:]
    )
  }
}
