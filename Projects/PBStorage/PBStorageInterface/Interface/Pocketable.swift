//
//  Pocketable.swift
//  PBStorage
//
//  Created by 이시원 on 6/12/25.
//

import SwiftData

public protocol Pocketable {
  var title: String { get set }
  var colorIndex: Int { get set }
  var icon: String? { get set }
}
