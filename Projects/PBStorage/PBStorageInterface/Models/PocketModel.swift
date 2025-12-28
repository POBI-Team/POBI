//
//  PocketModel.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

public struct Pocket: Pocketable {
  public var title: String
  public var onAlarm: Bool
  public var repeats: Bool
  public var isCalendar: Bool
  public var colorIndex: Int
  public var icon: String
  public var alarm: Alarm
  
  public init(
    title: String = "",
    onAlarm: Bool = false,
    repeats: Bool = false,
    isCalendar: Bool = false,
    colorIndex: Int = 0,
    icon: String? = nil,
    alarm: Alarm = Alarm()
  ) {
    self.title = title
    self.onAlarm = onAlarm
    self.repeats = repeats
    self.isCalendar = isCalendar
    self.colorIndex = colorIndex
    self.icon = icon ?? "❤️"
    self.alarm = alarm
  }
}
