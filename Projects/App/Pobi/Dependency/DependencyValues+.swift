//
//  DependencyValues+.swift
//  Pobi
//
//  Created by 이시원 on 7/8/25.
//

import PBStorageInterface

import ComposableArchitecture

extension DependencyValues {
  var profileStorage: ProfileStorable {
    get { self[ProfileStorageKey.self] }
    set { self[ProfileStorageKey.self] = newValue }
  }
}
