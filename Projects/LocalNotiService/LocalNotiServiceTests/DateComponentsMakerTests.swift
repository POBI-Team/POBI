//
//  DateComponentsMakerTests.swift
//  LocalNotiServiceTests
//
//  Created by 이시원 on 8/1/25.
//

import XCTest
@testable import LocalNotiService

final class DateComponentsMakerTests: XCTestCase {
  var sut: DateComponentsMaker!
  override func setUpWithError() throws {
    sut = DateComponentsMaker()
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_make를_호출해_DateComponents_배열을_생성할_때_start_8월31일_end_9월2일인_경우_8월31일_9월1일2일_DateComponents가_생성된다() {
    // Arrange
    let startDate = Calendar.current.date(from: DateComponents(year:2025, month: 8, day: 31, hour: 9, minute: 9))!
    let endDate: Date? = Calendar.current.date(from: DateComponents(year:2025, month: 9, day: 2, hour: 11, minute: 11))
    let timeDate = Calendar.current.date(from: DateComponents(hour: 10, minute: 10))!
    // Act
    let output = sut.make(type: .date(start: startDate, end: endDate), time: timeDate)
    // Assert
    let result: [DateComponents] = [
      DateComponents(year:2025, month: 8, day: 31, hour: 10, minute: 10),
      DateComponents(year:2025, month: 9, day: 1, hour: 10, minute: 10),
      DateComponents(year:2025, month: 9, day: 2, hour: 10, minute: 10)
    ]
    XCTAssertEqual(result, output)
  }
  
  func test_make를_호출해_DateComponents_배열을_생성할_때_start_8월31일_end_nil_경우_8월31일_DateComponents가_생성된다() {
    // Arrange
    let startDate = Calendar.current.date(from: DateComponents(year:2025, month: 8, day: 31, hour: 9, minute: 9))!
    let endDate: Date? = nil
    let timeDate = Calendar.current.date(from: DateComponents(hour: 10, minute: 10))!
    // Act
    let output = sut.make(type: .date(start: startDate, end: endDate), time: timeDate)
    // Assert
    let result: [DateComponents] = [
      DateComponents(year:2025, month: 8, day: 31, hour: 10, minute: 10)
    ]
    XCTAssertEqual(result, output)
  }
  
  func test_make를_호출해_DateComponents_배열을_생성할_때_start_8월31일_end_8월31일로_동일할_경우_8월31일_DateComponents가_생성된다() {
    // Arrange
    let startDate = Calendar.current.date(from: DateComponents(year:2025, month: 8, day: 31, hour: 9, minute: 9))!
    let endDate: Date? = Calendar.current.date(from: DateComponents(year:2025, month: 8, day: 31, hour: 11, minute: 11))!
    let timeDate = Calendar.current.date(from: DateComponents(hour: 10, minute: 10))!
    // Act
    let output = sut.make(type: .date(start: startDate, end: endDate), time: timeDate)
    // Assert
    let result: [DateComponents] = [
      DateComponents(year:2025, month: 8, day: 31, hour: 10, minute: 10)
    ]
    XCTAssertEqual(result, output)
  }
}
