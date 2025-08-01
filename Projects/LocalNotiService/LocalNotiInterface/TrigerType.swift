//
//  TrigerType.swift
//  LocalNotiService
//
//  Created by 이시원 on 3/24/25.
//

import UserNotifications

@frozen public enum TrigerType: Equatable {
  case day(days: [Int])
  case week(weeks: [Int])
  case date(start: Date, end: Date?)
}
