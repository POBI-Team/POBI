//
//  PBCalender.swift
//  PBCalender
//
//  Created by 이시원 on 5/1/25.
//

import Foundation
import Combine

public final class PBCalender: Sendable, ObservableObject {
  public init() {}
  
  /// 1. 년도와 월 입력 시 배열 형태로 날짜 반환
  public func numberOfDays(in date: Date) -> Int {
    Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }
}
