//
//  TrigerType.swift
//  LocalNotiService
//
//  Created by 이시원 on 3/24/25.
//

import UserNotifications

public enum TrigerType {
  case day(days: [Int])
  case week(weeks: [Int])
  case date(Date)
  
  func requsetIds(id: String) -> [String] {
    switch self {
    case let .day(days):
      return days.map { id + "-\($0)" }
    case let .week(weeks):
      return weeks.map { id + "-\($0)" }
    case let .date(date):
      return [id + "-\(date.description)"]
    }
  }
  
  func makeRequsts(time: Date, id: String, content: UNMutableNotificationContent) -> [UNNotificationRequest] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH-m"
    let splitedTime = dateFormatter
      .string(from: time)
      .split(separator: "-")
      .compactMap({ Int($0) })
    let hour = splitedTime[0]
    let minute = splitedTime[1]
    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minute
    
    switch self {
    case let .day(days): // 매달 특정 일에 반복
      return Array(zip(days, self.requsetIds(id: id)))
        .map { (day: Int, id: String) in
          dateComponents.day = day
          let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
          return UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: triger
          )
        }
    case let .week(weeks): // 매주 특정 요일마다 반복
      return Array(zip(weeks, self.requsetIds(id: id)))
        .map { (week: Int, id: String) in
          dateComponents.weekday = week
          let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
          return UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: triger
          )
        }
    case let .date(date): // 특정 날짜 하루
      dateFormatter.dateFormat = "yyyy-M-d"
      let splitedDate = dateFormatter
        .string(from: date)
        .components(separatedBy: "-")
        .compactMap { Int($0) }
      dateComponents.year = splitedDate[0]
      dateComponents.month = splitedDate[1]
      dateComponents.day = splitedDate[2]
      let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      return [
        UNNotificationRequest(
          identifier: self.requsetIds(id: id)[0],
          content: content,
          trigger: triger
        )
      ]
    }
  }
}
