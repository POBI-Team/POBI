//
//  PocketItemModel.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import SwiftData

@Model
public final class PocketItemModel {
  @Attribute(.unique) public var id: UUID
  public var title: String
  public var memeo: String
  public var isChecked: Bool
  
  public init(id: UUID, title: String, memeo: String, isChecked: Bool = false) {
    self.id = id
    self.title = title
    self.memeo = memeo
    self.isChecked = isChecked
  }
}
