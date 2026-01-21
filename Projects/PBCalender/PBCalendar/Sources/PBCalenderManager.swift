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
  
  public func days(in date: Date, with pockets: [CDPocketModel] = []) -> [PBCalendarItem] {
    let startFirstWeekdayIndex = (firstWeekdayOfMonth(in: date) - calendar.firstWeekday + 7) % 7
    let lastDay = numberOfDays(in: date)
    let lastDayOfMonthBefore = numberOfDays(in: previousMonth(at: date))
    let rowCount = ceil((Double(lastDay + startFirstWeekdayIndex) / 7))
    let visibleDaysCountOfNextMonth = Int(rowCount) * 7 - (lastDay + startFirstWeekdayIndex)
    let weekdays = weekdays
    return Array(-startFirstWeekdayIndex..<lastDay + visibleDaysCountOfNextMonth)
      .enumerated()
      .map { i, e -> PBCalendarItem in
        let day: Int
        let isToday: Bool
        let isInCurrentMonth: Bool
        let weekday = weekdays[i%7]
        var targetPockets: [CDPocketModel] = []
        
        if e > -1 && e < lastDay { // 현재 달
          day = e + 1
          isInCurrentMonth = true
        } else if e >= lastDay { // 이후 달
          day = e - lastDay + 1
          isInCurrentMonth = false
        } else { // 이전 달
          day = lastDayOfMonthBefore + e + 1
          isInCurrentMonth = false
        }
        let itemDateComponents = dateComponents(of: day, in: date, weekday: weekday, isInCurrentMonth: isInCurrentMonth)
        isToday = calendar.date(.now, matchesComponents: itemDateComponents)
        let date = calendar.date(from: itemDateComponents)
        pockets.forEach { pocket in
          guard isToday || pocket.createAt < date! || !pocket.repeats else { return }
          if pocket.repeats {
            if pocket.alarm.isWeekRepeat {
              if pocket.alarm.daysValue.contains(weekday) {
                targetPockets.append(pocket)
              }
            } else {
              if pocket.alarm.daysValue.contains(day) {
                targetPockets.append(pocket)
              }
            }
          } else {
            if let endDate = pocket.alarm.endDate {
              if (date! >= pocket.alarm.date && date! <= endDate) ||
                  calendar.date(pocket.alarm.date, matchesComponents: itemDateComponents) ||
                  calendar.date(endDate, matchesComponents: itemDateComponents) {
                targetPockets.append(pocket)
              }
            } else if calendar.date(pocket.alarm.date, matchesComponents: itemDateComponents) {
              targetPockets.append(pocket)
            }
          }
        }
        return PBCalendarItem(
          id: itemDateComponents.description,
          dateComponents: itemDateComponents,
          isToday: isToday,
          isInCurrentMonth: isInCurrentMonth,
          pockets: targetPockets
        )
      }
  }
}

private extension PBCalendarManager {
  func dateComponents(of day: Int, in date: Date, weekday: Int, isInCurrentMonth: Bool) -> DateComponents {
    var components = calendar.dateComponents([.year, .month], from: date)
    components.day = day
    components.weekday = weekday
    if !isInCurrentMonth {
      if day > 15 {
        components.month! -= 1
      } else {
        components.month! += 1
      }
    }
    return components
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
