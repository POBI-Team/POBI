//
//  TemplateModel+CoreDataClass.swift
//  
//
//  Created by 이시원 on 12/17/25.
//
//

public import Foundation
public import CoreData

public typealias CDTemplateModelCoreDataClassSet = NSSet

@objc(TemplateModel)
public class CDTemplateModel: NSManagedObject {
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    self.id = UUID()
    self.createAt = Date.now
    self.title = ""
    self.colorIndex = 7
    self.items = []
  }
}
