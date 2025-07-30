//
//  NotificationName+.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import Foundation
import SwiftUI

import PBStorageInterface
import PBDesignSystem

extension NSNotification.Name {
  static let skip = NSNotification.Name("Skip")
  static let createPocket =  NSNotification.Name("CreatePocket")
}

extension ProfileImageType {
  public var profileImage: Image {
    switch self {
    case .first:
      PBImages.profileFirst.image
    case .second:
      PBImages.profileSecond.image
    @unknown default:
      fatalError("profileImage not found")
    }
  }
}
