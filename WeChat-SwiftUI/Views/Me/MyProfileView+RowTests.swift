import XCTest
import SwiftUIRedux
@testable import WeChat_SwiftUI

private typealias Row = MyProfileView.Row
private typealias SubRow = MyProfileView.Row.SubRow

final class MyProfileView_RowTests: XCTestCase {

  func test_row_subRows() {
    XCTAssertEqual(Row.photo.subRows.count, 0)
    XCTAssertEqual(Row.name.subRows.count, 0)
    XCTAssertEqual(Row.wechatId.subRows.count, 0)
    XCTAssertEqual(Row.qrCode.subRows.count, 0)
    XCTAssertEqual(Row.more.subRows, [.gender, .region, .whatsUp])
  }

  func test_row_title() {
    XCTAssertEqual(Row.photo.title, Strings.me_profile_photo())
    XCTAssertEqual(Row.name.title, Strings.general_name())
    XCTAssertEqual(Row.wechatId.title, Strings.general_wechat_id())
    XCTAssertEqual(Row.qrCode.title, Strings.me_my_qr_code())
    XCTAssertEqual(Row.more.title, Strings.general_more())
  }

  func test_row_destinationPresentation() {
    XCTAssertEqual(Row.photo.destinationPresentation.style, .push)
    XCTAssertEqual(Row.name.destinationPresentation.style, .modal)
    XCTAssertEqual(Row.wechatId.destinationPresentation.style, .push)
    XCTAssertEqual(Row.qrCode.destinationPresentation.style, .push)
    XCTAssertEqual(Row.more.destinationPresentation.style, .push)
  }

  func test_subRow_title() {
    XCTAssertEqual(SubRow.gender.title, Strings.general_gender())
    XCTAssertEqual(SubRow.region.title, Strings.general_region())
    XCTAssertEqual(SubRow.whatsUp.title, Strings.general_whats_up())
  }

  func test_subRow_destinationPresentation() {
    XCTAssertEqual(SubRow.gender.destinationPresentation.style, .modal)
    XCTAssertEqual(SubRow.region.destinationPresentation.style, .modal)
    XCTAssertEqual(SubRow.whatsUp.destinationPresentation.style, .modal)
  }
}
