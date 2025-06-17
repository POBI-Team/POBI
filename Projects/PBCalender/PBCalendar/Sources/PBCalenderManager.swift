//
//  PBCalendarManager.swift
//  PBCalendar
//
//  Created by 이시원 on 5/1/25.
//

import Foundation
import Combine

import PBStorageInterface

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
  
  public func days(in date: Date, with pockets: [PocketModel] = []) -> [PBCalendarItem] {
    let startfirstWeekdayIndex = firstWeekdayOfMonth(in: date) - calendar.firstWeekday // 사용자의 캘린더 시작 날짜에 따라 첫일이 시작하는 시점
    let lastDay = numberOfDays(in: date)
    let lastDayOfMonthBefore = numberOfDays(in: previousMonth(at: date))
    let rowCount = ceil((Double(lastDay + startfirstWeekdayIndex) / 7))
    let visibleDaysCountOfNextMonth = Int(rowCount) * 7 - (lastDay + startfirstWeekdayIndex)
    let weekdays = weekdays
    return Array(-startfirstWeekdayIndex..<lastDay + visibleDaysCountOfNextMonth)
      .enumerated()
      .map { i, e -> PBCalendarItem in
        let day: Int
        let isToday: Bool
        let isInCurrentMonth: Bool
        let weekday = weekdays[i%7]
        var targetPockets: [PocketModel] = []
        
        if e > -1 && e < lastDay { // 현재 달
          day = e + 1
          isToday = self.isToday(date: date, day: e + 1)
          isInCurrentMonth = true
        } else if e >= lastDay { // 이후 달
          day = e - lastDay + 1
          isToday = false
          isInCurrentMonth = false
        } else { // 이전 달
          day = lastDayOfMonthBefore + e + 1
          isToday = false
          isInCurrentMonth = false
        }
        
        let date = self.date(of: day, in: date, isInCurrentMonth: isInCurrentMonth)
        pockets.forEach { pocket in
          if pocket.repeats {
            if pocket.alarm.isWeekRepeat {
              if pocket.alarm.days.contains(weekday) {
                targetPockets.append(pocket)
              }
            } else {
              if pocket.alarm.days.contains(day) {
                targetPockets.append(pocket)
              }
            }
          } else {
            if compare(pocket.alarm.date, with: date) {
              targetPockets.append(pocket)
            }
          }
        }
        return PBCalendarItem(
          id: makeComponents(for: date, day: day).description,
          dateComponents: calendar.dateComponents([.year, .month, .day, .weekday], from: date),
          isToday: isToday,
          isInCurrentMonth: isInCurrentMonth,
          pockets: targetPockets
        )
      }
  }
  
  public func date(of day: Int, in date: Date, isInCurrentMonth: Bool) -> Date {
    var components = calendar.dateComponents([.year, .month], from: date)
    components.day = day
    let date = calendar.date(from: components)!
    if isInCurrentMonth {
      return date
    } else {
      if day > 15 {
        return calendar.date(byAdding: .month, value: -1, to: date)!
      } else {
        return calendar.date(byAdding: .month, value: 1, to: date)!
      }
    }
  }
}

private extension PBCalendarManager {
  func compare(_ date1: Date, with date2: Date) -> Bool {
    calendar.dateComponents([.year, .month, .day], from: date1).description == calendar.dateComponents([.year, .month, .day], from: date2).description
  }
  
  func isToday(date: Date, day: Int) -> Bool {
    calendar.date(
      .now,
      matchesComponents: makeComponents(for: date, day: day)
    )
  }
  
  func makeComponents(for date: Date, day: Int) -> DateComponents {
    return DateComponents(
      year: calendar.component(.year, from: date),
      month: calendar.component(.month, from: date),
      day: day
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
