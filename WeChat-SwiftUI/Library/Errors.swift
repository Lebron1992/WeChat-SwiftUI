import Foundation

extension NSError {
  static var unknowError: Error {
    NSError(
      domain: "",
      code: -1,
      userInfo: [NSLocalizedDescriptionKey: Strings.general_unknown_error()]
    )
  }

  static func commonError(description: String) -> NSError {
    NSError(
      domain: "",
      code: -1,
      userInfo: [NSLocalizedDescriptionKey: description]
    )
  }
}
