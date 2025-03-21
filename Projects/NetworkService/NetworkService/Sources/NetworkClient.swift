//
//  NetworkClient.swift
//  NetworkService
//
//  Created by 이시원 on 3/21/25.
//

import Foundation

import NetworkServiceInterface

public final class NetworkClient: NetworkRequestable {
  private let urlSession: URLSession
  private let jsonDecoder = JSONDecoder()
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  public func request<T: Decodable>(target: any TargetAPI, of type: T.Type) async throws(ServiceError) -> T {
    let (data, response) = try await request(target: target)
    
    switch response.statusCode {
    case 200..<300:
      do {
        let dto = try jsonDecoder.decode(type.self, from: data)
        return dto
      } catch {
        throw .decode(reason: .decodeFailure(type.self))
      }
    case 400: throw .network(reason: .badRequest)
    case 401: throw .network(reason: .unauthorized)
    case 404: throw .network(reason: .notFound)
    default: throw .network(reason: .unknown)
    }
  }
  
  private func request(target: any TargetAPI) async throws(ServiceError) -> (Data, HTTPURLResponse) {
    var urlRequest = try target.asURLRequest()    
    guard let (data, response) = try? await urlSession.data(for: urlRequest),
          let response = response as? HTTPURLResponse else {
      throw .network(reason: .unknown)
    }
    return (data, response)
  }
}
