//
//  CDPocketAlarmModel+CoreDataClass.swift
//  
//
//  Created by 이시원 on 12/16/25.
//
//

public import Foundation
public import CoreData

public typealias CDPocketAlarmModelCoreDataClassSet = NSSet

@objc(PocketAlarmModel)
public class CDPocketAlarmModel: NSManagedObject {
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    self.isWeekRepeat = true
    self.daysValue = [1,2,3,4,5,6,7]
    self.date = Date.now
    self.time = Date.now
  }
}
