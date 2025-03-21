//
//  ServiceError.swift
//  NetworkService
//
//  Created by 이시원 on 3/21/25.
//

import Foundation

public enum ServiceError: LocalizedError {
  public enum NetworkReason: CustomStringConvertible, Sendable {
    case createURLRequestFailure
    case badRequest
    case unauthorized
    case notFound
    case unknown
    
    public var description: String {
      switch self {
      case .createURLRequestFailure:
        return "URL 생성 실패"
      case .badRequest:
        return "잘못된 요청"
      case .unauthorized:
        return "유효하지 않은 인증"
      case .notFound:
        return "페이지를 찾을 수 없음"
      case .unknown:
        return "알 수 없는 에러"
      }
    }
  }
  
  public enum DecodeReason: CustomStringConvertible, Sendable {
    case decodeFailure(Any.Type)
    
    public var description: String {
      switch self {
      case .decodeFailure(let type):
        return "\(type) 디코딩에 실패했습니다."
      }
    }
  }
  
  case network(reason: NetworkReason)
  case decode(reason: DecodeReason)

  public var errorDescription: String? {
    switch self {
    case .network(reason: let reason):
      reason.description
    case .decode(reason: let reason):
      reason.description
    }
  }
}
