//
//  PocketModel+.swift
//  Pobi
//
//  Created by 이시원 on 4/8/25.
//

import PBStorageInterface
import LocalNotiService
import LocalNotiInterface

extension PocketModel {
  public func registerPushAlarm(userNickname: String) {
    LocalNotiCenter.shared.register(
      title: "POBI",
      body: "똑똑! \(userNickname)님 '\(title)' 소지품 챙기세요!",
      id: id.uuidString,
      trigerType: pushType,
      time: alarm.time
    )
  }
  
  public func deletePushAlarm() {
    LocalNotiCenter.shared.remove(id: id.uuidString, type: pushType, time: alarm.time)
  }
  
  public var pushType: TrigerType {
    if repeats {
      if alarm.isWeekRepeat {
        return .week(weeks: alarm.days)
      } else {
        return .day(days: alarm.days)
      }
    } else {
      return .date(start: alarm.date, end: alarm.endDate)
    }
  }
}
