//
//  DateComponentsMaker.swift
//  LocalNotiService
//
//  Created by 이시원 on 8/1/25.
//

import LocalNotiInterface

struct DateComponentsMaker {
  func make(type: RepeatType, time: Date) -> [DateComponents] {
    let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
    switch type {
    case let .day(days):
      return days.map { day in
        var newComponents = timeComponents
        newComponents.day = day
        return newComponents
      }
    case let .week(weeks):
      return weeks.map { week in
        var newComponents = timeComponents
        newComponents.weekOfYear = week
        return newComponents
      }
    case let .date(start, end):
      var startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: start)
      var startDate = start
      startDateComponents.hour = timeComponents.hour
      startDateComponents.minute = timeComponents.minute
      var dateComponents: [DateComponents] = [startDateComponents]
      guard let end else { return dateComponents }
      let endDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: end)
      while startDateComponents < endDateComponents {
        startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
        startDateComponents.hour = timeComponents.hour
        startDateComponents.minute = timeComponents.minute
        dateComponents.append(startDateComponents)
      }
      return dateComponents
    }
  }
}

private extension DateComponents {
  func date(using calendar: Calendar = .current) -> Date? {
    return calendar.date(from: self)
  }
  
  static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
    guard let lDate = lhs.date(), let rDate = rhs.date() else {
      fatalError("비교하려는 DateComponents 중 Date로 변환할 수 없는 값이 있습니다.")
    }
    return lDate < rDate
  }
  
  static func == (lhs: DateComponents, rhs: DateComponents) -> Bool {
    guard let lDate = lhs.date(), let rDate = rhs.date() else {
      return false
    }
    return lDate == rDate
  }
}
