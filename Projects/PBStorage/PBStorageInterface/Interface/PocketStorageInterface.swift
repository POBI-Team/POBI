//
//  PocketStorageInterface.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

public protocol PocketStorageInterface: Sendable {  
  func read<T: PocketModelable>(_ type: T.Type, sortBy sorts: [SortDescriptor<T>], filter: Predicate<T>?) throws -> [T]
  func insert<T: PocketModelable>(_ model: T)
  func delete<T: PocketModelable>(_ model: T)
}
