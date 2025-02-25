//
//  Storable.swift
//  PBStorage
//
//  Created by 이시원 on 2/25/25.
//

import SwiftData

public protocol Storable {
  associatedtype Model: PersistentModel
  
  func read(_ predicate: Predicate<Model>?) throws -> [Model]
  func insert(_ pocket: Model)
  func delete(_ id: UUID) throws
}
