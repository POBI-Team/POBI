//
//  ProfileStorage.swift
//  PBStorage
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI
import Combine

import PBStorageInterface

public final class ProfileStorage: ProfileStorable, ObservableObject, @unchecked Sendable {
  private let userDefaults: UserDefaults
  
  public init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  public func saveNotFirstEntry() {
    userDefaults.set(true, forKey: "firstEntry")
  }
  
  public func loadNotFirstEntry() -> Bool {
    return userDefaults.bool(forKey: "firstEntry")
  }
  
  public func saveNickname(_ nickname: String) {
    userDefaults.set(nickname, forKey: "nickname")
  }
  
  public func loadNickname() -> String? {
    return userDefaults.string(forKey: "nickname")
  }
  
  public func saveProfileImageType(_ type: ProfileImageType) {
    userDefaults.set(type.rawValue, forKey: "profile")
  }
  
  public func loadProfileImageType() -> ProfileImageType? {
    guard let rawValue = userDefaults.string(forKey: "profile") else { return nil }
    return ProfileImageType(rawValue: rawValue)
  }
}
