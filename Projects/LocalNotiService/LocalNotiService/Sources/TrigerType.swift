//
//  TrigerType.swift
//  LocalNotiService
//
//  Created by 이시원 on 3/24/25.
//

import UserNotifications

public enum TrigerType {
  case day(days: [UInt])
  case week(weeks: [Weekday])
  case date(year: UInt, month: UInt, day: UInt)
  
  public enum Weekday: Int, CaseIterable {
    case mon = 1
    case tues
    case wednes
    case thurs
    case fri
    case satur
    case sun
    
    public static func weekday(string: String) -> Weekday? {
      switch string {
      case "월": return .mon
      case "화": return .tues
      case "수": return .wednes
      case "목": return .thurs
      case "금": return .fri
      case "토": return .satur
      case "일": return .sun
      default: return nil
      }
    }
  }
  
  func requsetIds(id: String) -> [String] {
    switch self {
    case let .day(days):
      return days.map { id + "-\($0)" }
    case let .week(weeks):
      return weeks.map { id + "-\($0.rawValue)" }
    case let .date(year, month, day):
      return [id + "-\(year)" + "-\(month)" + "-\(day)"]
    }
  }
  
  func makeRequsts(hour: UInt, minute: UInt, id: String, content: UNMutableNotificationContent) -> [UNNotificationRequest] {
    switch self {
    case let .day(days): // 매달 특정 일에 반복
      return Array(zip(days, self.requsetIds(id: id)))
        .map { (day: UInt, id: String) in
          var dateComponents = DateComponents()
          dateComponents.day = Int(day)
          dateComponents.hour = Int(hour)
          dateComponents.minute = Int(minute)
          let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
          return UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: triger
          )
        }
    case let .week(weeks): // 매주 특정 요일마다 반복
      return Array(zip(weeks, self.requsetIds(id: id)))
        .map { (week: Weekday, id: String) in
          var dateComponents = DateComponents()
          dateComponents.weekday = week.rawValue
          dateComponents.hour = Int(hour)
          dateComponents.minute = Int(minute)
          let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
          return UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: triger
          )
        }
    case let .date(year, month, day): // 특정 날짜 하루
      var dateComponents = DateComponents()
      dateComponents.year = Int(year)
      dateComponents.month = Int(month)
      dateComponents.day = Int(day)
      dateComponents.hour = Int(hour)
      dateComponents.minute = Int(minute)
      let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      return [
        UNNotificationRequest(
          identifier: self.requsetIds(id: id).first!,
          content: content,
          trigger: triger
        )
      ]
    }
  }
}
