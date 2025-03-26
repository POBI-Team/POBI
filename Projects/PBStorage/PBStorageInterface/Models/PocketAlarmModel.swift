//
//  PocketAlarmModel.swift
//  PBStorage
//
//  Created by 이시원 on 3/26/25.
//

import SwiftData

@Model
public final class PocketAlarmModel {
  public var date: String
  public var hour: Int
  public var minute: Int
  
  public init(date: String, hour: Int, minute: Int) {
    self.date = date
    self.hour = hour
    self.minute = minute
  }
}
