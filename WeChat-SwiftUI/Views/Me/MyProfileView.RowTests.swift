import XCTest
import ComposableArchitecture
@testable import WeChat_SwiftUI

private typealias Row = MyProfileView.Row
private typealias SubRow = MyProfileView.Row.SubRow

final class MyProfileView_RowTests: XCTestCase {

  let user = User.template1!
  let store = Store(
    initialState: AppState(),
    reducer: appReducer
  )

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

  func test_row_navigateDestination() {
    XCTAssertEqual(Row.photo.navigateDestination(with: user).style, .push)
    XCTAssertEqual(Row.name.navigateDestination(with: user).style, .modal)
    XCTAssertEqual(Row.wechatId.navigateDestination(with: user).style, .push)
    XCTAssertEqual(Row.qrCode.navigateDestination(with: user).style, .push)
    XCTAssertEqual(Row.more.navigateDestination(with: user).style, .push)
  }

  func test_subRow_title() {
    XCTAssertEqual(SubRow.gender.title, Strings.general_gender())
    XCTAssertEqual(SubRow.region.title, Strings.general_region())
    XCTAssertEqual(SubRow.whatsUp.title, Strings.general_whats_up())
  }

  func test_subRow_navigateDestination() {
    XCTAssertEqual(SubRow.gender.navigateDestination(with: user).style, .modal)
    XCTAssertEqual(SubRow.region.navigateDestination(with: user).style, .modal)
    XCTAssertEqual(SubRow.whatsUp.navigateDestination(with: user).style, .modal)
  }
}
