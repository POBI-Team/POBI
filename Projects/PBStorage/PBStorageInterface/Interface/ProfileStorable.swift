//
//  ProfileStorable.swift
//  PBStorage
//
//  Created by 이시원 on 7/8/25.
//

public protocol ProfileStorable: Sendable {
  func saveNotFirstEntry()
  func loadNotFirstEntry() -> Bool
  func saveNickname(_ nickname: String)
  func loadNickname() -> String?
  func saveProfileImageType(_ type: ProfileImageType)
  func loadProfileImageType() -> ProfileImageType?
}

public enum ProfileImageType: String {
  case first
  case second
}
