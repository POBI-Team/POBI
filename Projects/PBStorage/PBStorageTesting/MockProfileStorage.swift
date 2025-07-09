//
//  MockProfileStorage.swift
//  PBStorageTesting
//
//  Created by 이시원 on 7/8/25.
//

import PBStorageInterface

public final class MockProfileStorage: ProfileStorable, @unchecked Sendable {
  public var count: Int = 0
  
  public init() {
    
  }
  
  public func saveNotFirstEntry() {
    print(#function)
  }
  
  public func loadNotFirstEntry() -> Bool {
    print(#function)
    return true
  }
  
  public func saveNickname(_ nickname: String) {
    print(#function)

  }
  
  public func loadNickname() -> String? {
    print(#function)
    count += 1
    return nil
  }
  
  public func saveProfileImageType(_ type: ProfileImageType) {
    print(#function)

  }
  
  public func loadProfileImageType() -> ProfileImageType? {
    print(#function)
    return .first
  }
}
