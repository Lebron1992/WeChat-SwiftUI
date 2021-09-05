import UIKit

extension Message.Image {
  struct URLImage {
    let url: String
    let width: CGFloat
    let height: CGFloat
  }
}

extension Message.Image.URLImage: Codable { }

extension Message.Image.URLImage: Equatable { }
