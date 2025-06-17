//
//  PBCalendarItem.swift
//  PBCalender
//
//  Created by 이시원 on 5/13/25.
//

import PBStorageInterface

public struct PBCalendarItem: @unchecked Sendable, Identifiable {
  public let id: String
  public let dateComponents: DateComponents
  public let isToday: Bool
  public let isInCurrentMonth: Bool
  public var pockets: [PocketModel]
  
  public init(id: String, dateComponents: DateComponents, isToday: Bool, isInCurrentMonth: Bool, pockets: [PocketModel]) {
    self.id = id + "\(isInCurrentMonth)"
    self.dateComponents = dateComponents
    self.isToday = isToday
    self.isInCurrentMonth = isInCurrentMonth
    self.pockets = pockets
  }
}
