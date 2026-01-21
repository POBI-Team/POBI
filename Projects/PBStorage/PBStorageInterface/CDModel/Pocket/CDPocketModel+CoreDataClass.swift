//
//  CDPocketModel+CoreDataClass.swift
//  
//
//  Created by 이시원 on 12/16/25.
//
//

public import Foundation
public import CoreData

public typealias CDPocketModelCoreDataClassSet = NSSet

@objc(PocketModel)
public class CDPocketModel: NSManagedObject {
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    self.id = UUID()
    self.title = ""
    self.onAlarm = false
    self.repeats = false
    self.colorIndex = 0
    self.isCalendar = false
    self.createAt = Date.now
    let alarm = CDPocketAlarmModel(context: managedObjectContext!)
    alarm.pocket = self
    self.alarm = alarm
    self.items = []
  }
}
