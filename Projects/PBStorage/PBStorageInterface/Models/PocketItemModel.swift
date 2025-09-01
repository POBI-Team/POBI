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
  public var memo: String
  public var isChecked: Bool
  public var sortIndex: Int 

  public init(
    id: UUID = UUID(),
    title: String = "",
    memo: String = "",
    isChecked: Bool = false,
    sortIndex: Int = 0
  ) {
    self.id = id
    self.title = title
    self.memo = memo
    self.isChecked = isChecked
    self.sortIndex = sortIndex
  }
  
  public func copy() -> PocketItemModel {
    return PocketItemModel(
      title: self.title,
      memo: self.memo,
      sortIndex: self.sortIndex
    )
  }
}

extension Array where Element: PocketItemModel {
  public func updateSortIndices() {
    for (index, item) in self.enumerated() {
      item.sortIndex = index
    }
  }
}

public struct PocketItem {
  public let id: UUID
  public let title: String
  public let memo: String
  public let isChecked: Bool
  public let sortIndex: Int
  
  public init(
    id: UUID = .init(),
    title: String = "",
    memo: String = "",
    isChecked: Bool = false,
    sortIndex: Int = 0
  ) {
    self.id = id
    self.title = title
    self.memo = memo
    self.isChecked = isChecked
    self.sortIndex = sortIndex
  }
  
  public init(model: PocketItemModel) {
    self.id = model.id
    self.title = model.title
    self.memo = model.memo
    self.isChecked = model.isChecked
    self.sortIndex = model.sortIndex
  }
  
  public func toModel() -> PocketItemModel {
    return .init(id: self.id, title: self.title, memo: self.memo, isChecked: self.isChecked, sortIndex: self.sortIndex)
  }
}
