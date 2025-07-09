//
//  CreatePocketFeature.swift
//  Pobi
//
//  Created by 이시원 on 7/8/25.
//

import PBStorageInterface

import ComposableArchitecture

@Reducer
struct CreatePocketFeature {
  
  @ObservableState
  struct State: Equatable {
  }
  
  enum Action {
  }
  
  @Dependency(\.profileStorage) var profileStorage
  @Dependency(\.localNotiCenter) var localNotiCenter
  @Dependency(\.firebaseManager) var firebaseManager
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      }
      return .none
    }
  }
}
