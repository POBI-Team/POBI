//
//  CDPocketModel+CoreDataProperties.swift
//
//
//  Created by 이시원 on 12/16/25.
//
//

public import Foundation
public import CoreData


public typealias CDPocketModelCoreDataPropertiesSet = NSSet

extension CDPocketModel: CDPocketModelable {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPocketModel> {
    return NSFetchRequest<CDPocketModel>(entityName: "PocketModel")
  }
  
  @NSManaged public var id: UUID
  @NSManaged public var title: String
  @NSManaged public var onAlarm: Bool
  @NSManaged public var repeats: Bool
  @NSManaged public var colorIndex: Int64
  @NSManaged public var icon: String?
  @NSManaged public var isCalendar: Bool
  @NSManaged public var createAt: Date
  @NSManaged public var alarm: CDPocketAlarmModel
  @NSManaged public var items: Set<CDPocketItemModel>
  
  public convenience init(with pocket: Pocket, context: NSManagedObjectContext) {
    self.init(context: context)
    self.title = pocket.title
    self.onAlarm = pocket.onAlarm
    self.repeats = pocket.repeats
    self.colorIndex = Int64(pocket.colorIndex)
    self.icon = pocket.icon
    self.isCalendar = pocket.isCalendar
    let alarm = CDPocketAlarmModel(with: pocket.alarm, context: context)
    alarm.pocket = self
    self.alarm = alarm
  }
  
}

// MARK: Generated accessors for items
extension CDPocketModel {
  
  @objc(addItemsObject:)
  @NSManaged public func addToItems(_ value: CDPocketItemModel)
  
  @objc(removeItemsObject:)
  @NSManaged public func removeFromItems(_ value: CDPocketItemModel)
  
  @objc(addItems:)
  @NSManaged public func addToItems(_ values: Set<CDPocketItemModel>)
  
  @objc(removeItems:)
  @NSManaged public func removeFromItems(_ values: Set<CDPocketItemModel>)
  
  public func copyModel() -> CDPocketModel {
    let newPocket = CDPocketModel(context: managedObjectContext!)
    newPocket.title = self.title
    newPocket.onAlarm = self.onAlarm
    newPocket.repeats = self.repeats
    newPocket.colorIndex = self.colorIndex
    newPocket.icon = self.icon
    newPocket.alarm = self.alarm.copyModel()
    newPocket.alarm.pocket = newPocket
    newPocket.items = Set(self.items.map { $0.copyModel() })
    return newPocket
  }
  
  public func template() -> CDTemplateModel {
    let template = CDTemplateModel(context: managedObjectContext!)
    template.title = self.title
    template.icon = self.icon
    template.items = Set(self.items.map { $0.copyModel() })
    return template
  }
  
  public func temporary() -> Pocket {
    return Pocket(
      title: self.title,
      onAlarm: self.onAlarm,
      repeats: self.repeats,
      isCalendar: self.isCalendar,
      colorIndex: Int(self.colorIndex),
      icon: self.icon,
      alarm: self.alarm.temporary()
    )
  }
  
  public func paste(_ pocket: Pocket) {
    self.title = pocket.title
    self.onAlarm = pocket.onAlarm
    self.repeats = pocket.repeats
    self.colorIndex = Int64(pocket.colorIndex)
    self.icon = pocket.icon
    self.alarm.paste(pocket.alarm)
    self.isCalendar = pocket.isCalendar
  }
}
