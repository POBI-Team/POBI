//
//  CDPocketAlarmModel+CoreDataProperties.swift
//
//
//  Created by 이시원 on 12/16/25.
//
//

public import Foundation
public import CoreData


public typealias CDPocketAlarmModelCoreDataPropertiesSet = NSSet

extension CDPocketAlarmModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPocketAlarmModel> {
    return NSFetchRequest<CDPocketAlarmModel>(entityName: "PocketAlarmModel")
  }
  
  @NSManaged public var isWeekRepeat: Bool
  @NSManaged public var date: Date
  @NSManaged public var endDate: Date?
  @NSManaged public var time: Date
  @NSManaged public var pocket: CDPocketModel?
  @NSManaged private var days: NSObject
  public var daysValue: [Int] {
    get {
      if let data = days as? Data,
         let days = try? JSONDecoder().decode([Int].self, from:data) {
        return days
      }
      guard let days = days as? [NSNumber] else { return [] }
      return days.map(\.intValue)
    }
    set { days = newValue.map { NSNumber(integerLiteral: $0) } as NSObject }
  }
  
  public convenience init(with alarm: Alarm, context: NSManagedObjectContext) {
    self.init(context: context)
    self.isWeekRepeat = alarm.isWeekRepeat
    self.daysValue = alarm.days
    self.date = alarm.date
    self.endDate = alarm.endDate
    self.time = alarm.time
  }
}

extension CDPocketAlarmModel {
  public func copyModel() -> CDPocketAlarmModel {
    let newAlarm = CDPocketAlarmModel(context: self.managedObjectContext!)
    newAlarm.isWeekRepeat = self.isWeekRepeat
    newAlarm.daysValue = self.daysValue
    newAlarm.date = self.date
    newAlarm.endDate = self.endDate
    newAlarm.time = self.time
    
    return newAlarm
  }
  
  public func temporary() -> Alarm {
    return Alarm(
      isWeekRepeat: self.isWeekRepeat,
      days: self.daysValue,
      date: self.date,
      endDate: self.endDate,
      time: self.time
    )
  }
  
  public func paste(_ alarm: Alarm) {
    self.isWeekRepeat = alarm.isWeekRepeat
    self.daysValue = alarm.days
    self.date = alarm.date
    self.endDate = alarm.endDate
    self.time = alarm.time
  }
}
