//
//  PBCalendarTests.swift
//  PBCalendarTests
//
//  Created by 이시원 on 5/1/25.
//

import XCTest
@testable import PBCalendar

final class PBCalendarTests: XCTestCase {
  private var sut: PBCalendarManager!
  
  override func setUp() {
    sut = PBCalendarManager()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func test_weeks_호출_시_시작_요일이_월요일인_경우_월부터_시작해서_일로_끝() {
    // Arrange
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    sut = PBCalendarManager(caledar: calendar)
    // Act
    let output = sut.weekdays
    // Assert
    XCTAssertEqual([2,3,4,5,6,7,1], output)
  }
  
  func test_days_호출_시_3월의_달력은_2월23일부터_4월5일까지_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    // Act
    let output = sut.days(in: date)
    // Assert
    XCTAssertEqual([23, 24, 25, 26, 27, 28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 1, 2, 3, 4, 5], output.map(\.day))
  }
  
  func test_days_호출_시_사용자의_달력_시작요일이_화요일인_경우_3월의_달력은_2월25일부터_3월31일까지_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    var calendar = Calendar.current
    calendar.firstWeekday = 3
    sut = PBCalendarManager(caledar: calendar)
    // Act
    let output = sut.days(in: date)
    // Assert
    XCTAssertEqual([25, 26, 27, 28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], output.map(\.day))
  }
  
  func test_date_호출_시_입력한_날짜가_16일이면서_해당_월에_포함되어_있는_경우_해당_월에_16일() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    // Act
    let item = PBCalendarItem(day: 16, isToday: false, isInCurrentMonth: true)
    let output = sut.date(of: item, in: date)
    // Assert
    let result = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 16))!
    XCTAssertEqual(result, output)
  }
  
  func test_date_호출_시_입력한_날짜가_28일이면서_해당_월에_포함되어_있는_않는_경우_이전_월에_28일() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    // Act
    let item = PBCalendarItem(day: 28, isToday: false, isInCurrentMonth: false)
    let output = sut.date(of: item, in: date)
    // Assert
    let result = Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 28))!
    XCTAssertEqual(result, output)
  }
  
  func test_date_호출_시_입력한_날짜가_2일이면서_해당_월에_포함되어_있는_않는_경우_다음_월에_2일() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    // Act
    let item = PBCalendarItem(day: 2, isToday: false, isInCurrentMonth: false)
    let output = sut.date(of: item, in: date)
    // Assert
    let result = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 2))!
    XCTAssertEqual(result, output)
  }
}
