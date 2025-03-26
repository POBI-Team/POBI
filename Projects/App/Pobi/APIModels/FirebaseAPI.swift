//
//  FirebaseAPI.swift
//  Pobi
//
//  Created by 이시원 on 3/25/25.
//

import NetworkServiceInterface

enum FirebaseAPI {
  case icons
}

extension FirebaseAPI: TargetAPI {
  var baseURL: String {
    switch self {
    case .icons:
      "https://pobi-470c2-default-rtdb.firebaseio.com/"
    }
  }
  
  var path: String {
    switch self {
    case .icons:
      "icons.json"
    }
  }
  
  var method: NetworkServiceInterface.HTTPMethod {
    switch self {
    case .icons:
        .get
    }
  }
  
  var headers: [String : String] {
    ["Content-Type" : "application/json"]
  }
  
  var body: (any Encodable)? {
    nil
  }
  
  var query: (any Encodable)? {
    nil
  }
}
