//
//  TargetAPI.swift
//  NetworkService
//
//  Created by 이시원 on 3/21/25.
//

import Foundation

public protocol TargetAPI {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var body: Encodable? { get }
  var query: Encodable? { get }
}

extension TargetAPI {
  private func createURL() throws(ServiceError) -> URL? {
    let urlString = baseURL + path
    
    guard let query,
          var urlComponents = URLComponents(string: urlString)
    else { return URL(string: urlString) }
    urlComponents.queryItems = []
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    guard let object = try? encoder.encode(query),
          let dictionary = try? JSONSerialization.jsonObject(with: object) as? [String: Any]
    else {
      throw .decode(reason: .decodeFailure(type(of: query)))
    }
    
    dictionary
      .forEach({ key, value in
        let item = URLQueryItem(name: key, value: "\(value)")
        urlComponents.queryItems?.append(item)
      })
    
    return urlComponents.url
  }
  
  public func asURLRequest() throws(ServiceError) -> URLRequest {
    guard let url = try createURL() else {
      throw .network(reason: .createURLRequestFailure)
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    
    if let body {
      guard let jsonData = try? JSONEncoder().encode(body) else {
        throw ServiceError.decode(reason: .decodeFailure(type(of: body)))
      }
      urlRequest.httpBody = jsonData
    }
    
    headers.forEach {
      urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    
    return urlRequest
  }
}
