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
  public var time: Date
  
  public init(date: String, time: Date) {
    self.date = date
    self.time = time
  }
}
