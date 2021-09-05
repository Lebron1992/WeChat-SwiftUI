import UIKit

extension CGSize {
  /// 返回在给定的 size 内的等比例缩放的最大 size
  func aspectSize(fitsSize size: CGSize) -> CGSize {
    let heightFitsWidth = (size.width * height) / width

    if heightFitsWidth > size.height {
      let widthFitsHeight = (size.height * width) / height
      return .init(width: widthFitsHeight, height: size.height)
    }

    return .init(width: size.width, height: heightFitsWidth)
  }
}
