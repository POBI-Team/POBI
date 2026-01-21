//
//  MockPocketStorage.swift
//  PBStorage
//
//  Created by 이시원 on 7/13/25.
//

import PBStorageInterface
import CoreData

public final class MockPocketStorage: StorageInterface, @unchecked Sendable {
  public var context: NSManagedObjectContext
  
  public struct CallCount {
    public var save: Int = 0
    public var delete: Int = 0
  }
  
  public struct ReturnValue {}
  
  public struct InputValue {
    public var delete: NSManagedObject?
  }
  
  public var callCount: CallCount = .init()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()
  
  public init() {
    let modelURL = Bundle(for: CDPocketModel.self).url(forResource: "CDPobiModel", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    let container = NSPersistentContainer(name: "CDPobiModel", managedObjectModel: model)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores(completionHandler: { _, _ in })
    context = container.viewContext
  }
  
  public func delete<T>(_ model: T) where T : NSManagedObject {
    callCount.delete += 1
    inputValue.delete = model
  }
  
  public func save() throws {
    callCount.save += 1
  }
}
