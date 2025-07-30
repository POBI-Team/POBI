//
//  ProfileStorageKey.swift
//  Pobi
//
//  Created by 이시원 on 7/8/25.
//

import PBStorage
import PBStorageInterface

import ComposableArchitecture

struct ProfileStorageKey: DependencyKey {
  static let liveValue: any ProfileStorable = ProfileStorage()
}
