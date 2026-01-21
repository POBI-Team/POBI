//
//  CDPocketItemModel+CoreDataProperties.swift
//  
//
//  Created by 이시원 on 12/16/25.
//
//

public import Foundation
public import CoreData


public typealias CDPocketItemModelCoreDataPropertiesSet = NSSet

extension CDPocketItemModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPocketItemModel> {
    return NSFetchRequest<CDPocketItemModel>(entityName: "PocketItemModel")
  }
  
  @NSManaged public var id: UUID
  @NSManaged public var title: String
  @NSManaged public var memo: String
  @NSManaged public var isChecked: Bool
  @NSManaged public var sortIndex: Int64
  @NSManaged public var pocket: CDPocketModel?
  @NSManaged public var template: CDTemplateModel?
  
}

extension CDPocketItemModel {
  public func copyModel() -> CDPocketItemModel {
    let newItem = CDPocketItemModel(context: self.managedObjectContext!)
    newItem.title = self.title
    newItem.memo = self.memo
    newItem.sortIndex = self.sortIndex
    return newItem
  }
}
