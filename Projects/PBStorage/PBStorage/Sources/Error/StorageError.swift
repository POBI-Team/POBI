//
//  StorageError.swift
//  PBStorage
//
//  Created by 이시원 on 1/13/26.
//

import Foundation

enum StorageError: LocalizedError {
  enum StorageReason: CustomStringConvertible, Sendable {
    case invalidPrivateStoreDescriptionCopy
    case failedToGetContainerIdentifier
    case failedToLoadPersistent
    
    var description: String {
      switch self {
      case .invalidPrivateStoreDescriptionCopy:
        "Error code: 001"
      case .failedToGetContainerIdentifier:
        "Error code: 002"
      case .failedToLoadPersistent:
        "Error code: 003"
      }
    }
  }
  
  case storage(reason: StorageReason)
  
  var errorDescription: String? {
    switch self {
    case .storage(reason: let reason):
      "영구 저장소를 불러오는 과정에서 에러가 발생했습니다.\n반복적으로 발생한다면 에러 코드와 함께 문의주세요.\n\(reason.description)\n문의 방법: 설정 > 포비에게 카톡하기"
    }
  }
}
