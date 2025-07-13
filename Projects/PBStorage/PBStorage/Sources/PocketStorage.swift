//
//  PocketStorage.swift
//  PBStorage
//
//  Created by 이시원 on 7/10/25.
//

import SwiftData

import PBStorageInterface
 
public final class PocketStorage: PocketStorageInterface, @unchecked Sendable {  
  private let modelContext: ModelContext
  
  public init?(isStoredInMemoryOnly: Bool = false) {
    let schema = Schema([PocketModel.self, PocketItemModel.self, PocketAlarmModel.self, TemplateModel.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
    guard let modelContainer = try? ModelContainer(for: schema, configurations: modelConfiguration) else { return nil }
    self.modelContext = ModelContext(modelContainer)
  }
  
  public func read<T: PocketModelable>(
    _ type: T.Type,
    sortBy sorts: [SortDescriptor<T>] = [],
    filter: Predicate<T>? = nil
  ) throws -> [T] {
    let descriptor = FetchDescriptor<T>(predicate: filter, sortBy: sorts)
    return try modelContext.fetch(descriptor)
  }
  
  public func insert<T: PocketModelable>(_ model: T) {
    modelContext.insert(model)
  }
  
  public func delete<T: PocketModelable>(_ model: T) {
    modelContext.delete(model)
  }
}
