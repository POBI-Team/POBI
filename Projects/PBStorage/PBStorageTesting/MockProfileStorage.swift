//
//  MockProfileStorage.swift
//  PBStorageTesting
//
//  Created by 이시원 on 7/8/25.
//

import PBStorageInterface

public final class MockProfileStorage: ProfileStorable, @unchecked Sendable {
  public struct CallCount {
    public var saveNotFirstEntry: Int = 0
    public var loadNotFirstEntry: Int = 0
    public var saveNickname: Int = 0
    public var loadNickname: Int = 0
    public var saveProfileImageType: Int = 0
    public var loadProfileImageType: Int = 0
  }
  
  public struct ReturnValue {
    public var loadNotFirstEntry: Bool = false
    public var loadNickname: String? = nil
    public var loadProfileImageType: ProfileImageType? = nil
  }
  
  public struct InputValue {
    public var saveNickname: String?
    public var saveProfileImageType: ProfileImageType?
  }
  
  public var callCount = CallCount()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()
  
  public init() {}
  
  public func saveNotFirstEntry() {
    callCount.saveNotFirstEntry += 1
  }
  
  public func loadNotFirstEntry() -> Bool {
    callCount.loadNotFirstEntry += 1
    return returnValue.loadNotFirstEntry
  }
  
  public func saveNickname(_ nickname: String) {
    callCount.saveNickname += 1
    inputValue.saveNickname = nickname
  }
  
  public func loadNickname() -> String? {
    callCount.loadNickname += 1
    return returnValue.loadNickname
  }
  
  public func saveProfileImageType(_ type: ProfileImageType) {
    callCount.saveProfileImageType += 1
    inputValue.saveProfileImageType = type
  }
  
  public func loadProfileImageType() -> ProfileImageType? {
    callCount.loadProfileImageType += 1
    return returnValue.loadProfileImageType
  }
}
