import Foundation

/// 作为 `Effect` 的 Output 类型，表示某个操作处理成功。目的是让 App Action 能自动实现 `Equatable` 协议
struct Success {}

extension Success: Equatable {}
