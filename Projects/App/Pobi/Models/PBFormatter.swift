//
//  PBFormatter.swift
//  Pobi
//
//  Created by 이시원 on 4/3/25.
//

import Foundation

final class PBFormatter: Sendable, ObservableObject {
  private let weeks = [2,3,4,5,6,7,1] // 월요일 부터 시작
  let dateFormatter = DateFormatter()
  
  func alarmLabel(_ date: Date, endDate: Date?) -> String {
    var label = self.label(date, format: "yy년 M월 d일")
    if let endDate {
      let startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
      let endDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: endDate)
      if startDateComponents.year != endDateComponents.year {
        label += " - " + self.label(endDate, format: "yy년 M월 d일")
      } else if startDateComponents.month != endDateComponents.month {
        label += " - " + self.label(endDate, format: "M월 d일")
      } else if startDateComponents.day != endDateComponents.day {
        label += " - " + self.label(endDate, format: "d일")
      }
    }
    return label
  }
  
  func label(_ date: Date, endDate: Date? = nil, format: String, locale: Locale? = nil) -> String {
    dateFormatter.dateFormat = format
    dateFormatter.locale = locale
    return dateFormatter.string(from: date)
  }
  
  func label(isWeekDay: Bool, days: [Int]) -> String {
    if isWeekDay {
      if days.count == 7 {
        return "매일"
      } else {
        return "매주 \(weeks.filter { days.contains($0) }.compactMap { weekDay($0) }.joined(separator: ", "))"
      }
    } else {
      if days.count == 31 {
        return "매일"
      } else {
        return "매월 \(days.map { String($0) }.joined(separator: ", "))일"
      }
    }
  }
  
  func weekDay(_ day: Int) -> String? {
    switch day {
    case 1: "일"
    case 2: "월"
    case 3: "화"
    case 4: "수"
    case 5: "목"
    case 6: "금"
    case 7: "토"
    default: nil
    }
  }
}
