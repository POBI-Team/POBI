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
  @Relationship(deleteRule: .cascade) public var items: [PocketItemModel]
  public var createAt: Date = Date()
  
  init(id: UUID, title: String, items: [PocketItemModel] = []) {
    self.id = id
    self.title = title
    self.items = items
  }
}
