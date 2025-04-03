//
//  PBFormatter.swift
//  Pobi
//
//  Created by 이시원 on 4/3/25.
//

import Foundation

final class PBFormatter: Sendable {
  static let shared = PBFormatter()
  let dateFormatter = DateFormatter()
  
  func label(_ date: Date, format: String) -> String {
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
  
  func label(isWeekDay: Bool, days: [Int]) -> String {
    if isWeekDay {
      if days.count == 7 {
        return "매일"
      } else {
        return "매주 \(days.compactMap { weekDay($0) }.joined(separator: ", "))"
      }
    } else {
      if days.count == 31 {
        return "매일"
      } else {
        return "매월 \(days.map { String($0) }.joined(separator: ", "))일"
      }
    }
  }
  
  private func weekDay(_ day: Int) -> String? {
    switch day {
    case 1: "월"
    case 2: "화"
    case 3: "수"
    case 4: "목"
    case 5: "금"
    case 6: "토"
    case 7: "일"
    default: nil
    }
  }
}
