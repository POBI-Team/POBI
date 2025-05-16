//
//  PBCalendarManager.swift
//  PBCalendar
//
//  Created by 이시원 on 5/1/25.
//

import Foundation
import Combine

public final class PBCalendarManager: Sendable, ObservableObject {
  private let calendar: Calendar
  public init(caledar: Calendar = .current) {
    self.calendar = caledar
  }
  
  public var weekdays: [Int] {
    return [0,1,2,3,4,5,6].map {
      let week = (calendar.firstWeekday + $0) % 7
      return week == 0 ? 7 : week
    }
  }
  
  public func days(in date: Date) -> [PBCalendarItem] {
    let startfirstWeekdayIndex = firstWeekdayOfMonth(in: date) - calendar.firstWeekday // 사용자의 캘린더 시작 날짜에 따라 첫일이 시작하는 시점
    let lastDay = numberOfDays(in: date)
    let lastDayOfMonthBefore = numberOfDays(in: previousMonth(at: date))
    let rowCount = ceil((Double(lastDay + startfirstWeekdayIndex) / 7))
    let visibleDaysCountOfNextMonth = Int(rowCount) * 7 - (lastDay + startfirstWeekdayIndex)
    return Array(-startfirstWeekdayIndex..<lastDay + visibleDaysCountOfNextMonth)
      .map { i -> PBCalendarItem in
        if i > -1 && i < lastDay { // 현재 달
          let day = i + 1
          return PBCalendarItem(day: day, isToday: isToday(date: date, day: day), isInCurrentMonth: true)
        } else if i >= lastDay { // 이후 달
          return PBCalendarItem(day: i - lastDay + 1, isToday: false, isInCurrentMonth: false)
        } else { // 이전 달
          return PBCalendarItem(day: lastDayOfMonthBefore + i + 1, isToday: false, isInCurrentMonth: false)
        }
      }
  }
  
  public func date(of item: PBCalendarItem, in date: Date) -> Date {
    var components = calendar.dateComponents([.year, .month], from: date)
    components.day = item.day
    let date = calendar.date(from: components)!
    if item.isInCurrentMonth {
      return date
    } else {
      if item.day > 15 {
        return calendar.date(byAdding: .month, value: -1, to: date)!
      } else {
        return calendar.date(byAdding: .month, value: 1, to: date)!
      }
    }
  }
}

private extension PBCalendarManager {
  func isToday(date: Date, day: Int) -> Bool {
    calendar.date(
      .now,
      matchesComponents: DateComponents(
        year: calendar.component(.year, from: date),
        month: calendar.component(.month, from: date),
        day: day
      )
    )
  }
  
  func numberOfDays(in date: Date) -> Int {
    calendar.range(of: .day, in: .month, for: date)?.count ?? 0
  }
  
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = calendar.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = calendar.date(from: components)!
    
    return calendar.component(.weekday, from: firstDayOfMonth)
  }
  
  func previousMonth(at date: Date) -> Date {
    let components = calendar.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = calendar.date(from: components)!
    return calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
  }
}
