//
//  PocketAlarmModel.swift
//  PBStorage
//
//  Created by 이시원 on 3/26/25.
//

public struct Alarm: Equatable {
  public var isWeekRepeat: Bool
  public var days: [Int]
  public var date: Date
  public var endDate: Date
  public var time: Date
  
  public init(
    isWeekRepeat: Bool = true,
    days: [Int] = [1,2,3,4,5,6,7],
    date: Date = .now,
    endDate: Date? = nil,
    time: Date = .now
  ) {
    self.isWeekRepeat = isWeekRepeat
    self.days = days
    self.date = date
    self.endDate = endDate ?? date
    self.time = time
  }
}
