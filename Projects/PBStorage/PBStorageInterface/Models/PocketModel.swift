//
//  PocketModel.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import SwiftData

@Model
public final class PocketModel {
  @Attribute(.unique) public var id: UUID
  public var title: String
  public var onAlarm: Bool = false
  public var repeats: Bool = false
  public var colorIndex = 0
  public var icon: String?
  public var isHidden: Bool = false
  @Relationship(deleteRule: .cascade) public var alarm: PocketAlarmModel?
  @Relationship(deleteRule: .cascade) public var items: [PocketItemModel] = []
  public var createAt: Date = Date()
  
  public init(id: UUID = UUID(), title: String = "") {
    self.id = id
    self.title = title
  }
  
  public static func copy(_ pocket: PocketModel) -> PocketModel {
    let newPocket = PocketModel(id: UUID(), title: pocket.title)
    newPocket.onAlarm = pocket.onAlarm
    newPocket.repeats = pocket.repeats
    newPocket.colorIndex = pocket.colorIndex
    newPocket.icon = pocket.icon
    newPocket.isHidden = pocket.isHidden
    newPocket.alarm = pocket.alarm
    newPocket.items = pocket.items
    return newPocket
  }
}
