//
//  TemplateModel+CoreDataProperties.swift
//
//
//  Created by 이시원 on 12/17/25.
//
//

public import Foundation
public import CoreData


public typealias TemplateModelCoreDataPropertiesSet = NSSet

extension CDTemplateModel: CDPocketModelable {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTemplateModel> {
    return NSFetchRequest<CDTemplateModel>(entityName: "TemplateModel")
  }
  
  @NSManaged public var id: UUID
  @NSManaged public var title: String
  @NSManaged public var colorIndex: Int64
  @NSManaged public var icon: String?
  @NSManaged public var createAt: Date
  @NSManaged public var items: Set<CDPocketItemModel>
  
  public convenience init(with template: Template, context: NSManagedObjectContext) {
    self.init(context: context)
    self.title = template.title
    self.icon = template.icon
  }
  
}

// MARK: Generated accessors for items
extension CDTemplateModel {
  
  @objc(addItemsObject:)
  @NSManaged public func addToItems(_ value: CDPocketItemModel)
  
  @objc(removeItemsObject:)
  @NSManaged public func removeFromItems(_ value: CDPocketItemModel)
  
  @objc(addItems:)
  @NSManaged public func addToItems(_ values: Set<CDPocketItemModel>)
  
  @objc(removeItems:)
  @NSManaged public func removeFromItems(_ values: Set<CDPocketItemModel>)
  
  public func temporary() -> Template {
    return Template(
      title: self.title,
      icon: self.icon,
    )
  }
  
  public func paste(_ template: Template) {
    self.title = template.title
    self.colorIndex = Int64(template.colorIndex)
    self.icon = template.icon
  }
}
