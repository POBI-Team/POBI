//
//  PocketAlarmModel.swift
//  PBStorage
//
//  Created by 이시원 on 3/26/25.
//

import SwiftData

@Model
public final class PocketAlarmModel {
  public var day: String
  public var date: Date
  public var time: Date
  
  public init(day: String, date: Date, time: Date) {
    self.day = day
    self.date = date
    self.time = time
  }
  
  public func copy() -> PocketAlarmModel {
    return PocketAlarmModel(day: self.day, date: self.date, time: self.time)
  }
}
