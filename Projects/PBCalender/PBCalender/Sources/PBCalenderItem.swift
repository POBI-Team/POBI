//
//  PBCalenderItem.swift
//  PBCalender
//
//  Created by 이시원 on 5/13/25.
//

public struct PBCalenderItem: Sendable {
  public let day: Int
  public let isToday: Bool
  public let isInCurrentMonth: Bool
  
  init(day: Int, isToday: Bool, isInCurrentMonth: Bool) {
    self.day = day
    self.isToday = isToday
    self.isInCurrentMonth = isInCurrentMonth
  }
}
