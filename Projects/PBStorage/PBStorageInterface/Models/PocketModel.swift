//
//  PocketModel.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import SwiftData

import LocalNotiService

@Model
public final class PocketModel {
  @Attribute(.unique) public var id: UUID
  public var title: String
  public var onAlarm: Bool
  public var repeats: Bool
  public var colorIndex: Int
  public var icon: String?
  public var isHidden: Bool
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
    isHidden: Bool = false,
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
    self.isHidden = isHidden
    self.alarm = alarm
    self.items = items
    self.createAt = createAt
  }
  
  public func copy() -> PocketModel {
    let newPocket = PocketModel(id: UUID(), title: self.title)
    newPocket.onAlarm = self.onAlarm
    newPocket.repeats = self.repeats
    newPocket.colorIndex = self.colorIndex
    newPocket.icon = self.icon
    newPocket.isHidden = self.isHidden
    newPocket.alarm = self.alarm.copy()
    newPocket.items = self.items.map { $0.copy() }
    return newPocket
  }
    
  public func deleteItem(withId id: UUID) {
    if let index = items.firstIndex(where: { $0.id == id }) {
      items.remove(at: index)
      updateSortIndices()
    }
  }
  
  public func appendItem(_ item: PocketItemModel) {
    item.sortIndex = items.count
    items.append(item)
  }
  
  public func updateSortIndices() {
    for (index, item) in items.enumerated() {
      item.sortIndex = index
    }
  }
  
  }
}
