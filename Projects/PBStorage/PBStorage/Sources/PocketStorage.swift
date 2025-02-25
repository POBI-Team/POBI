//
//  PocketStorage.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import SwiftData

import PBStorageInterface
 
public final class PocketStorage: Storable {
  private let modelContext: ModelContext
  
  public init(isStoredInMemoryOnly: Bool = false) throws {
    let schema = Schema([PocketModel.self, PocketItemModel.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
    let modelContainer = try ModelContainer(for: schema, configurations: modelConfiguration)
    self.modelContext = ModelContext(modelContainer)
  }
  
  public func read(_ predicate: Predicate<PocketModel>? = nil) throws -> [PocketModel] {
    let sort = SortDescriptor<PocketModel>(\.createAt, order: .forward)
    let descriptor = FetchDescriptor<PocketModel>(predicate: predicate, sortBy: [sort])
    return try modelContext.fetch(descriptor)
  }
  
  public func insert(_ pocket: PocketModel) {
    modelContext.insert(pocket)
  }
  
  public func delete(_ id: UUID) throws {
    let predicate = #Predicate<PocketModel> { $0.id == id }
    guard let deletePocket = try read(predicate).first else { return }
    modelContext.delete(deletePocket)
  }
}
