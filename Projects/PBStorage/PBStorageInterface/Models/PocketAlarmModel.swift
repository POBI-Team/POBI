//
//  PocketAlarmModel.swift
//  PBStorage
//
//  Created by 이시원 on 3/26/25.
//

import SwiftData

@Model
public final class PocketAlarmModel {
  public var isWeekRepeat: Bool
  public var days: [Int]
  public var date: Date
  public var time: Date
  
  public init(isWeekRepeat: Bool, days: [Int], date: Date, time: Date) {
    self.isWeekRepeat = isWeekRepeat
    self.days = days
    self.date = date
    self.time = time
  }
  
  public func copy() -> PocketAlarmModel {
    return PocketAlarmModel(
      isWeekRepeat: self.isWeekRepeat,
      days: self.days,
      date: self.date,
      time: self.time
    )
  }
}
