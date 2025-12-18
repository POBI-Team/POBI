//
//  CDPocketItemModel+CoreDataClass.swift
//  
//
//  Created by 이시원 on 12/16/25.
//
//

public import Foundation
public import CoreData

public typealias CDPocketItemModelCoreDataClassSet = NSSet

@objc(PocketItemModel)
public class CDPocketItemModel: NSManagedObject {
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    self.id = UUID()
    self.title = ""
    self.memo = ""
    self.isChecked = false
    self.sortIndex = 0
  }
}
