//
//  FirebaseAPI.swift
//  Pobi
//
//  Created by 이시원 on 3/25/25.
//

import NetworkServiceInterface

enum FirebaseAPI {
  case icons
  case items
  case banner
}

extension FirebaseAPI: TargetAPI {
  var baseURL: String {
    "https://pobi-470c2-default-rtdb.firebaseio.com/"
  }
  
  var path: String {
    switch self {
    case .icons:
      "icons.json"
    case .items:
      "items.json"
    case .banner:
      "banner.json"
    }
  }
  
  var method: NetworkServiceInterface.HTTPMethod {
    .get
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
