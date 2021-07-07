import UIKit

extension String {
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      attributes: [.font: font],
      context: nil
    )
    return ceil(boundingBox.height)
  }
}
