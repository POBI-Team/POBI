//
//  StorageInterface.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import CoreData

public protocol StorageInterface: Sendable {
  var context: NSManagedObjectContext { get }
  
  func save() throws
  func delete<T: NSManagedObject>(_ model: T)
}
