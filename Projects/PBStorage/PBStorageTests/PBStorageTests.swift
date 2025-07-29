//
//  PBStorageTests.swift
//  PBStorageTests
//
//  Created by 이시원 on 2/25/25.
//

import XCTest
@testable import PBStorage
@testable import PBStorageInterface

final class PBStorageTests: XCTestCase {
  var sut: PocketStorage!
  
  override func setUpWithError() throws {
    sut = PocketStorage(isStoredInMemoryOnly: true)
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_insert() {
    // Arrange
    let pockets = [
      PocketModel(title: "Test1", createAt: .now),
      PocketModel(title: "Test2", createAt: .init(timeIntervalSince1970: 0))
    ]
    // Act
    pockets.forEach {
      do {
        try sut.insert($0)
      } catch {
        XCTFail("저장 실패")
      }
    }
    // Assert
    do {
      let outputPocket = try sut.read(PocketModel.self, sortBy: [.init(\.createAt)]).map(\.title)
      XCTAssertEqual(outputPocket, pockets.reversed().map(\.title))
    } catch {
      XCTFail("읽기 실패")
    }
  }
  
  func test_delete() {
    // Arrange
    let pocket = PocketModel(title: "Test")
    do {
      try sut.insert(pocket)
    } catch {
      XCTFail("저장 실패")
    }
    // Act
    do {
      try sut.delete(pocket)
    } catch {
      XCTFail("삭제 실패")
    }
    // Assert
    do {
      let outputPocket = try sut.read(PocketModel.self, sortBy: [.init(\.createAt)])
      XCTAssertTrue(outputPocket.isEmpty)
    } catch {
      XCTFail("읽기 실패")
    }
  }
}
