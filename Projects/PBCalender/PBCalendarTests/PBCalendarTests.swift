//
//  PBCalendarTests.swift
//  PBCalendarTests
//
//  Created by 이시원 on 5/1/25.
//

import XCTest
import PBStorageInterface
@testable import PBCalendar
import CoreData

final class PBCalendarTests: XCTestCase {
  private var sut: PBCalendarManager!
  private var context: NSManagedObjectContext!
  
  override func setUp() {
    var calendar = Calendar.current
    calendar.firstWeekday = 1
    sut = PBCalendarManager(caledar: calendar)
    
    let modelURL = Bundle(for: CDPocketModel.self).url(forResource: "CDPobiModel", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    
    let container = NSPersistentContainer(name: "CDPobiModel", managedObjectModel: model)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores(completionHandler: { _, _ in })
    context = container.viewContext
  }
  
  override func tearDown() {
    sut = nil
    context = nil
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
    XCTAssertEqual([23, 24, 25, 26, 27, 28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 1, 2, 3, 4, 5], output.map(\.dateComponents.day!))
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
    XCTAssertEqual([25, 26, 27, 28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], output.map(\.dateComponents.day!))
  }
  
  func test_days_호출_시_10일에_포켓이_등록되어_있을_경우_10일에_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    let pockets: [CDPocketModel] = [
      CDPocketModel(
        with: Pocket(
          title: "10일 하루",
          alarm: .init(
            isWeekRepeat: false,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 10))!
          )
        ),
        context: context
      )
    ]
    // Act
    let output = sut.days(in: date, with: pockets)
      .filter { item in
        !item.pockets.isEmpty
      }
      .map { item in
        item.pockets.map {
          "\(item.dateComponents.day!), \($0.title)"
        }
      }
    // Assert
    XCTAssertEqual([["10, 10일 하루"]], output)
  }
  
  func test_days_호출_시_date와_endDate가_10일로_동일할_경우_10일에_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    let pockets: [CDPocketModel] = [
      CDPocketModel(
        with: Pocket(
          title: "10일 하루",
          alarm: .init(
            isWeekRepeat: false,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 10))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 10, hour: 11, minute: 11))!
          )
        ),
        context: context
      )
    ]
    // Act
    let output = sut.days(in: date, with: pockets)
      .filter { item in
        !item.pockets.isEmpty
      }
      .map { item in
        item.pockets.map {
          "\(item.dateComponents.day!), \($0.title)"
        }
      }
    // Assert
    XCTAssertEqual([["10, 10일 하루"]], output)
  }
  
  func test_days_호출_시_date_3월30일_endDate_4월2일인_경우_30일_부터_4일까지_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    let pockets: [CDPocketModel] = [
      CDPocketModel(
        with: Pocket(
          title: "3월 30일 ~ 4월 2일",
          alarm: .init(
            isWeekRepeat: false,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 30, hour: 3, minute: 3))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 2, hour: 11, minute: 11))!
          )
        ),
        context: context
      )
    ]
    // Act
    let output = sut.days(in: date, with: pockets)
      .filter { item in
        !item.pockets.isEmpty
      }
      .map { item in
        item.pockets.map {
          "\(item.dateComponents.day!), \($0.title)"
        }
      }
    // Assert
    XCTAssertEqual([["30, 3월 30일 ~ 4월 2일"], ["31, 3월 30일 ~ 4월 2일"], ["1, 3월 30일 ~ 4월 2일"], ["2, 3월 30일 ~ 4월 2일"]], output)
  }
  
  func test_days_호출_시_일요일_반복_포켓이_등록되어_있을_경우_매주_일요일에_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    let pockets: [CDPocketModel] = [
      CDPocketModel(
        with: Pocket(
          title: "일요일마다",
          repeats: true,
          alarm: .init(
            days: [1]
          )
        ),
        context: context
      )
    ]
    pockets[0].createAt = Calendar.current.date(from: DateComponents(year: 2025, month: 2))!
    // Act
    let output = sut.days(in: date, with: pockets)
      .filter { item in
        !item.pockets.isEmpty
      }
      .map { item in
        item.pockets.map {
          "\(item.dateComponents.day!), \($0.title)"
        }
      }
    // Assert
    XCTAssertEqual([["23, 일요일마다"], ["2, 일요일마다"], ["9, 일요일마다"], ["16, 일요일마다"], ["23, 일요일마다"], ["30, 일요일마다"]], output)
  }
  
  func test_days_호출_시_24일_반복_포켓이_등록되어_있을_경우_매달_24일에_표시() {
    // Arrange
    let date = Calendar.current.date(from: DateComponents(year: 2025, month: 3))! // 2025년 3월
    let pockets: [CDPocketModel] = [
      CDPocketModel(
        with: Pocket(
          title: "24일 마다",
          repeats: true,
          alarm: .init(
            isWeekRepeat: false,
            days: [24]
          )
        ),
        context: context
      )

    ]
    pockets[0].createAt = Calendar.current.date(from: DateComponents(year: 2025, month: 2))!

    // Act
    let output = sut.days(in: date, with: pockets)
      .filter { item in
        !item.pockets.isEmpty
      }
      .map { item in
        item.pockets.map {
          "\(item.dateComponents.day!), \($0.title)"
        }
      }
    // Assert
    XCTAssertEqual([["24, 24일 마다"], ["24, 24일 마다"]], output)
  }
}
