//
//  Pocketable.swift
//  PBStorage
//
//  Created by 이시원 on 6/12/25.
//

import SwiftData

public protocol PocketModelable: PersistentModel {
  var id: UUID { get set }
  var title: String { get set }
  var colorIndex: Int { get set }
  var icon: String? { get set }
  var items: [PocketItemModel] { get set }
  var createAt: Date { get set }
}

public protocol Pocketable {
  var title: String { get set }
  var colorIndex: Int { get set }
  var icon: String? { get set }
}
