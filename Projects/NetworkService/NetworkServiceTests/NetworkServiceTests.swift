//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Created by 이시원 on 3/21/25.
//

import XCTest
@testable import NetworkService
@testable import NetworkServiceInterface

final class NetworkServiceTests: XCTestCase {
  var sut: NetworkClient!
  
  override func setUpWithError() throws {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: config)
    sut = NetworkClient(urlSession: urlSession)
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_request를_통해_네트워크_통신을_시도하였을_때_상태코드가_400이면_badRequest발생() async {
    // Arrange
    MockURLProtocol.response = HTTPURLResponse(
      url: URL(string: "https://dummy.com")!,
      statusCode: 400,
      httpVersion: "1.1",
      headerFields: nil
    )
    do {
      // Act
      _ = try await sut.request(target: MockAPI.test, of: [String].self)
      // Assert
      XCTFail()
    } catch {
      // Assert
      XCTAssertEqual(
        error.localizedDescription,
        ServiceError.network(reason: .badRequest).localizedDescription
      )
    }
  }
  
  func test_request를_통해_네트워크_통신을_시도하였을_때_상태코드가_401이면_unauthorized발생() async {
    // Arrange
    MockURLProtocol.response = HTTPURLResponse(
      url: URL(string: "https://dummy.com")!,
      statusCode: 401,
      httpVersion: "1.1",
      headerFields: nil
    )
    do {
      // Act
      _ = try await sut.request(target: MockAPI.test, of: [String].self)
      // Assert
      XCTFail()
    } catch {
      // Assert
      XCTAssertEqual(
        error.localizedDescription,
        ServiceError.network(reason: .unauthorized).localizedDescription
      )
    }
  }
  
  func test_request를_통해_네트워크_통신을_시도하였을_때_상태코드가_404이면_notFound발생() async {
    // Arrange
    MockURLProtocol.response = HTTPURLResponse(
      url: URL(string: "https://dummy.com")!,
      statusCode: 404,
      httpVersion: "1.1",
      headerFields: nil
    )
    do {
      // Act
      _ = try await sut.request(target: MockAPI.test, of: [String].self)
      // Assert
      XCTFail()
    } catch {
      // Assert
      XCTAssertEqual(
        error.localizedDescription,
        ServiceError.network(reason: .notFound).localizedDescription
      )
    }
  }
  
  func test_request를_통해_네트워크_통신을_시도하였을_때_상태코드가_200이면서_올바르지_않은_DTO로_파싱하였을_때_디코딩에러() async {
    // Arrange
    MockURLProtocol.response = HTTPURLResponse(
      url: URL(string: "https://dummy.com")!,
      statusCode: 200,
      httpVersion: "1.1",
      headerFields: nil
    )
    do {
      // Act
      _ = try await sut.request(target: MockAPI.test, of: [Int].self)
      // Assert
      XCTFail()
    } catch {
      // Assert
      XCTAssertEqual(
        error.localizedDescription,
        ServiceError.decode(reason: .decodeFailure([Int].self)).localizedDescription
      )
    }
  }
  
  func test_request를_통해_네트워크_통신을_시도하였을_때_상태코드가_200이면서_올바른_DTO로_파싱하였을_때_성공() async {
    // Arrange
    MockURLProtocol.response = HTTPURLResponse(
      url: URL(string: "https://dummy.com")!,
      statusCode: 200,
      httpVersion: "1.1",
      headerFields: nil
    )
    do {
      // Act
      let input = try await sut.request(target: MockAPI.test, of: [String].self)
      // Assert
      XCTAssertEqual(input, ["❤️"])
    } catch {
      // Assert
      XCTFail(error.localizedDescription)
    }
  }
}
