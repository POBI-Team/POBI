//
//  PocketModel.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import SwiftData



@Model
public final class PocketModel: PocketModelable {
  @Attribute(.unique) public var id: UUID
  public var title: String
  public var onAlarm: Bool
  public var repeats: Bool
  public var colorIndex: Int
  public var icon: String?
  public var isCalendar: Bool = false
  @Relationship(deleteRule: .cascade) public var alarm: PocketAlarmModel
  @Relationship(deleteRule: .cascade) public var items: [PocketItemModel]
  public var createAt: Date
  
  public init(
    id: UUID = UUID(),
    title: String = "",
    onAlarm: Bool = false,
    repeats: Bool = false,
    colorIndex: Int = 0,
    icon: String? = nil,
    isCalendar: Bool = false,
    alarm: PocketAlarmModel = .init(isWeekRepeat: true, days: [1,2,3,4,5,6,7], date: .now, time: .now),
    items: [PocketItemModel] = [],
    createAt: Date = .now
  ) {
    self.id = id
    self.title = title
    self.onAlarm = onAlarm
    self.repeats = repeats
    self.colorIndex = colorIndex
    self.icon = icon
    self.isCalendar = isCalendar
    self.alarm = alarm
    self.items = items
    self.createAt = createAt
  }
  
  public convenience init(_ pocket: Pocket) {
    self.init(
      title: pocket.title,
      onAlarm: pocket.onAlarm,
      repeats: pocket.repeats,
      colorIndex: pocket.colorIndex,
      icon: pocket.icon,
      isCalendar: pocket.isCalendar,
      alarm: .init(pocket.alarm)
    )
  }
  
  public func copy() -> PocketModel {
    let newPocket = PocketModel(id: UUID(), title: self.title)
    newPocket.onAlarm = self.onAlarm
    newPocket.repeats = self.repeats
    newPocket.colorIndex = self.colorIndex
    newPocket.icon = self.icon
    newPocket.alarm = self.alarm.copy()
    newPocket.items = self.items.map { $0.copy() }
    return newPocket
  }

  public func template() -> TemplateModel {
    return TemplateModel(
      title: self.title,
      icon: self.icon,
      items: self.items.map { $0.copy() }
    )
  }
  
  public func temporary() -> Pocket {
    return Pocket(
      title: self.title,
      onAlarm: self.onAlarm,
      repeats: self.repeats,
      isCalendar: self.isCalendar,
      colorIndex: self.colorIndex,
      icon: self.icon,
      alarm: self.alarm.temporary()
    )
  }
  
  public func paste(_ pocket: Pocket) {
    self.title = pocket.title
    self.onAlarm = pocket.onAlarm
    self.repeats = pocket.repeats
    self.colorIndex = pocket.colorIndex
    self.icon = pocket.icon
    self.alarm.paste(pocket.alarm)
    self.isCalendar = pocket.isCalendar
  }
}

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
