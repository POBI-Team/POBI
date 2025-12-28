//
//  PocketStorage.swift
//  PBStorage
//
//  Created by 이시원 on 7/10/25.
//

import CoreData
import CloudKit

import PBStorageInterface
 
public final class PocketStorage: @unchecked Sendable {
  public static let shared = PocketStorage()
  
  public var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  private var privatePersistentStore: NSPersistentStore?
  private var sharedPersistentStore: NSPersistentStore?
  private var persistentContainer: NSPersistentCloudKitContainer!
  
  public init() {}
  
  public func initializeContainer() throws {
    let cloudKitContainer = NSPersistentCloudKitContainer(name: "CDPobiModel")

    let privateStoreDescription = cloudKitContainer.persistentStoreDescriptions.first
    let storesURL = privateStoreDescription?.url?.deletingLastPathComponent()
    
    let privateStoreURL = storesURL?.appendingPathComponent("default.store")
    privateStoreDescription?.url = privateStoreURL
    
    let sharedStoreURL = storesURL?.appendingPathComponent("shared.store")
    guard let sharedStoreDescription = privateStoreDescription?.copy() as? NSPersistentStoreDescription else {
      fatalError("Copying the private store description returned an unexpected value.")
    }
    sharedStoreDescription.url = sharedStoreURL

    guard let containerIdentifier = privateStoreDescription?.cloudKitContainerOptions?.containerIdentifier else {
      fatalError("Unable to get containerIdentifier")
    }
    let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
    sharedStoreOptions.databaseScope = .shared
    sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
    cloudKitContainer.persistentStoreDescriptions.append(sharedStoreDescription)

    cloudKitContainer.loadPersistentStores { loadedStoreDescription, error in
      if let error = error as NSError? {
        fatalError("Failed to load persistent stores: \(error)")
      }
      
      else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
        guard let loadedStoreDescritionURL = loadedStoreDescription.url else {
          return
        }
        if cloudKitContainerOptions.databaseScope == .private {
          let privateStore = cloudKitContainer.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
          self.privatePersistentStore = privateStore
        } else if cloudKitContainerOptions.databaseScope == .shared {
          let sharedStore = cloudKitContainer.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
          self.sharedPersistentStore = sharedStore
        }
      }
    }
    
    cloudKitContainer.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    cloudKitContainer.viewContext.automaticallyMergesChangesFromParent = true
    try cloudKitContainer.viewContext.setQueryGenerationFrom(.current)

    persistentContainer = cloudKitContainer
  }
}

extension PocketStorage: StorageInterface {
  public func delete<T: NSManagedObject>(_ model: T) {
    context.delete(model)
  }
  
  public func save() throws {
    if context.hasChanges {
      try context.save()
    }
  }
}

