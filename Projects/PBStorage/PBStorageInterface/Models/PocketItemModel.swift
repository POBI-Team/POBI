//
//  PocketItemModel.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import CoreData

extension Array where Element: CDPocketItemModel {
  public func updateSortIndices() {
    for (index, item) in self.enumerated() {
      item.sortIndex = Int64(index)
    }
  }
}

public struct PocketItem {
  public var id: UUID
  public var title: String
  public var memo: String
  public var isChecked: Bool
  public var sortIndex: Int
  
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
  
  public init(model: CDPocketItemModel) {
    self.id = model.id
    self.title = model.title
    self.memo = model.memo
    self.isChecked = model.isChecked
    self.sortIndex = Int(model.sortIndex)
  }
  
  public func toModel(context: NSManagedObjectContext) -> CDPocketItemModel {
    let model: CDPocketItemModel = .init(context: context)
    model.id = self.id
    model.title = self.title
    model.memo = self.memo
    model.isChecked = self.isChecked
    model.sortIndex = Int64(self.sortIndex)
    return model    
  }
}
