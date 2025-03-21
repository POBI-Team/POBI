//
//  MockURLProtocol.swift
//  NetworkService
//
//  Created by 이시원 on 3/21/25.
//

import Foundation
import XCTest

final class MockURLProtocol: URLProtocol {
  nonisolated(unsafe) static var response: URLResponse?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    do {
      guard let response = Self.response else { return XCTFail("Non Response") }
      
      guard let url = Bundle(for: type(of: self)).url(forResource: "Dummy", withExtension: "json") else { return XCTFail("Non Json File") }
      let data = try Data(contentsOf: url)
      
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {}
}
