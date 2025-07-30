//
//  FirebaseManagerKey.swift
//  Pobi
//
//  Created by 이시원 on 7/9/25.
//

import LocalNotiService
import LocalNotiInterface

import ComposableArchitecture

struct FirebaseManagerKey: DependencyKey {
  static let liveValue: any FirebaseManagerInterface = FirebaseManager()
}
