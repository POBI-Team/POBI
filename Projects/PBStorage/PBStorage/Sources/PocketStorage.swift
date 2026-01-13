//
//  PocketStorage.swift
//  PBStorage
//
//  Created by 이시원 on 7/10/25.
//

import CoreData
import CloudKit
import Combine

import PBStorageInterface
 
public final class PocketStorage: @unchecked Sendable, ObservableObject {
  public static let shared = PocketStorage()
  
  public var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  private var privatePersistentStore: NSPersistentStore?
  private var sharedPersistentStore: NSPersistentStore?
  private var persistentContainer: NSPersistentCloudKitContainer!
  public var initializationError: Error? = nil
  
  public init() {}
  
  public func initializeContainer() {
    persistentContainer = NSPersistentCloudKitContainer(name: "CDPobiModel")

    let privateStoreDescription = persistentContainer.persistentStoreDescriptions.first
    let storesURL = privateStoreDescription?.url?.deletingLastPathComponent()
    
    let privateStoreURL = storesURL?.appendingPathComponent("default.store")
    privateStoreDescription?.url = privateStoreURL
    
    let sharedStoreURL = storesURL?.appendingPathComponent("shared.store")
    guard let sharedStoreDescription = privateStoreDescription?.copy() as? NSPersistentStoreDescription else {
      initializationError = StorageError.storage(reason: .invalidPrivateStoreDescriptionCopy)
      return
    }
    sharedStoreDescription.url = sharedStoreURL

    guard let containerIdentifier = privateStoreDescription?.cloudKitContainerOptions?.containerIdentifier else {
      initializationError = StorageError.storage(reason: .failedToGetContainerIdentifier)
      return
    }
    let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
    sharedStoreOptions.databaseScope = .shared
    sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
    persistentContainer.persistentStoreDescriptions.append(sharedStoreDescription)

    persistentContainer.loadPersistentStores { [weak self] loadedStoreDescription, error in
      if let _ = error as NSError? {
        self?.initializationError = StorageError.storage(reason: .failedToLoadPersistent)
      } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
        guard let self,
              let loadedStoreDescritionURL = loadedStoreDescription.url else { return }
        if cloudKitContainerOptions.databaseScope == .private {
          let privateStore = persistentContainer.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
          privatePersistentStore = privateStore
        } else if cloudKitContainerOptions.databaseScope == .shared {
          let sharedStore = persistentContainer.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
          sharedPersistentStore = sharedStore
        }
      }
    }
    persistentContainer.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
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

