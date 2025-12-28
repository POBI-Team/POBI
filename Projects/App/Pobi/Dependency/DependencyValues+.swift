//
//  DependencyValues+.swift
//  Pobi
//
//  Created by 이시원 on 7/8/25.
//

import PBStorageInterface
import LocalNotiInterface

import ComposableArchitecture

extension DependencyValues {
  var profileStorage: ProfileStorable {
    get { self[ProfileStorageKey.self] }
    set { self[ProfileStorageKey.self] = newValue }
  }
  
  var localNotiCenter: Notifiable {
    get { self[LocalNotiCenterKey.self] }
    set { self[LocalNotiCenterKey.self] = newValue }
  }
  
  var firebaseManager: FirebaseManagerInterface {
    get { self[FirebaseManagerKey.self] }
    set { self[FirebaseManagerKey.self] = newValue }
  }
  
  var pocketStorage: StorageInterface {
    get { self[PocketStorageKey.self] }
    set { self[PocketStorageKey.self] = newValue }
  }
}
