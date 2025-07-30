//
//  LocalNotiCenterKey.swift
//  Pobi
//
//  Created by 이시원 on 7/9/25.
//

import LocalNotiService
import LocalNotiInterface

import ComposableArchitecture

struct LocalNotiCenterKey: DependencyKey {
  static let liveValue: any Notifiable = LocalNotiCenter()
}
