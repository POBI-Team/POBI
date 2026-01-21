//
//  PocketStorageKey.swift
//  Pobi
//
//  Created by 이시원 on 7/13/25.
//

import PBStorage
import PBStorageInterface

import ComposableArchitecture

struct PocketStorageKey: DependencyKey {
  static let liveValue: (any StorageInterface) = PocketStorage.shared
}
