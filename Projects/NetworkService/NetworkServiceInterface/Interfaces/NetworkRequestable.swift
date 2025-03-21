//
//  NetworkRequestable.swift
//  NetworkService
//
//  Created by 이시원 on 3/21/25.
//

import Foundation

public protocol NetworkRequestable: AnyObject, Sendable {
  func request<T: Decodable>(target: TargetAPI, of type: T.Type) async throws(ServiceError) -> T
}
