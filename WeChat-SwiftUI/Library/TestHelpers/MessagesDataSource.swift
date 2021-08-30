import Foundation
import XCTest
@testable import WeChat_SwiftUI

protocol MessagesDataSource {
  func sortedMessages() -> (Message, Message, Message)
}

extension MessagesDataSource where Self: XCTestCase {
  func sortedMessages() -> (Message, Message, Message) {
    let now = Date()
    let m1 = Message(text: "1", createTime: now)
    let m2 = Message(text: "2", createTime: now.addingTimeInterval(10))
    let m3 = Message(text: "3", createTime: now.addingTimeInterval(20))
    return (m1, m2, m3)
  }
}
