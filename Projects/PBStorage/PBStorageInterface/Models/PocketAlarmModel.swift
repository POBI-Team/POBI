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
  
  public convenience init(_ alarm: Alarm) {
    self.init(isWeekRepeat: alarm.isWeekRepeat, days: alarm.days, date: alarm.date, time: alarm.time)
  }
  
  public func copy() -> PocketAlarmModel {
    return PocketAlarmModel(
      isWeekRepeat: self.isWeekRepeat,
      days: self.days,
      date: self.date,
      time: self.time
    )
  }
  
  public func temporary() -> Alarm {
    return Alarm(isWeekRepeat: self.isWeekRepeat, days: self.days, date: self.date, time: self.time)
  }
  
  public func paste(_ alarm: Alarm) {
    self.isWeekRepeat = alarm.isWeekRepeat
    self.days = alarm.days
    self.date = alarm.date
    self.time = alarm.time
  }
  
}

public struct Alarm {
  public var isWeekRepeat: Bool
  public var days: [Int]
  public var date: Date
  public var time: Date
  
  public init(
    isWeekRepeat: Bool = true,
    days: [Int] = [1,2,3,4,5,6,7],
    date: Date = .now,
    time: Date = .now
  ) {
    self.isWeekRepeat = isWeekRepeat
    self.days = days
    self.date = date
    self.time = time
  }
}
