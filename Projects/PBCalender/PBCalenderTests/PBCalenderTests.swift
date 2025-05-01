//
//  PBCalenderTests.swift
//  PBCalenderTests
//
//  Created by 이시원 on 5/1/25.
//

import XCTest
@testable import PBCalender

final class PBCalenderTests: XCTestCase {
  private var sut: PBCalender!
  
  override func setUp() {
    sut = PBCalender()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func test_numberOfDays를_통해_얻은_2025년_4월의_일자_수는_30() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 4))! // 2025년 4월
    // Act
    let output = sut.numberOfDays(in: date)
    // Assert
    XCTAssertEqual(output, 30)
  }
}
