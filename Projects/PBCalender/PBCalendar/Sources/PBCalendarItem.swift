//
//  PBCalendarItem.swift
//  PBCalender
//
//  Created by 이시원 on 5/13/25.
//

import PBStorageInterface

public struct PBCalendarItem: @unchecked Sendable, Identifiable {
  public let id = UUID()
  public let day: Int
  public let weekday: Int
  public let isToday: Bool
  public let isInCurrentMonth: Bool
  public let pockets: [PocketModel]
  
  init(day: Int, weekday: Int, isToday: Bool, isInCurrentMonth: Bool, pockets: [PocketModel]) {
    self.day = day
    self.weekday = weekday
    self.isToday = isToday
    self.isInCurrentMonth = isInCurrentMonth
    self.pockets = pockets
  }
}
