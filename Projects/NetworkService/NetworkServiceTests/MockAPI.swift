//
//  MockAPI.swift
//  NetworkService
//
//  Created by 이시원 on 3/21/25.
//

import NetworkServiceInterface

enum MockAPI {
  case test
}

extension MockAPI: TargetAPI {
  var baseURL: String {
    "https://test.com"
  }
  
  var path: String {
    ""
  }
  
  var method: HTTPMethod {
    .get
  }
  
  var headers: [String: String] {
    [:]
  }
  
  var body: (any Encodable)? {
    nil
  }
  
  var query: (any Encodable)? {
    nil
  }
}
