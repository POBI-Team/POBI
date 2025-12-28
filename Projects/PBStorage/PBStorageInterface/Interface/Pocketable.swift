//
//  Pocketable.swift
//  PBStorage
//
//  Created by 이시원 on 6/12/25.
//

import CoreData

public protocol CDPocketModelable: NSManagedObject {
  var id: UUID { get set }
  var title: String { get set }
  var colorIndex: Int64 { get set }
  var icon: String? { get set }
  var items: Set<CDPocketItemModel> { get set }
  var createAt: Date { get set }
  
  func addToItems(_ values: Set<CDPocketItemModel>)
}

public protocol Pocketable: Equatable {
  var title: String { get set }
  var colorIndex: Int { get set }
  var icon: String { get set }
}
