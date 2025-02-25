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
    sut = try PocketStorage(isStoredInMemoryOnly: true)
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_insert() {
    // Arrange
    let items = [
      PocketItemModel(id: .init(), title: "first", memeo: "aa"),
      PocketItemModel(id: .init(), title: "second", memeo: "bb"),
      PocketItemModel(id: .init(), title: "third", memeo: "cc")
    ]
    let pocket = PocketModel(id: .init(), title: "Test", items: items)
    // Act
    sut.insert(pocket)
    // Assert
    do {
      let outputPocket = try sut.read().first!
      XCTAssertEqual(outputPocket, pocket)
    } catch {
      XCTFail("읽기 실패")
    }
  }
  
  func test_delete() {
    // Arrange
    let items = [
      PocketItemModel(id: .init(), title: "first", memeo: "aa"),
      PocketItemModel(id: .init(), title: "second", memeo: "bb")
    ]
    let pocket = PocketModel(id: .init(), title: "Test", items: items)
    sut.insert(pocket)
    // Act
    do {
      try sut.delete(pocket.id)
    } catch {
      XCTFail("삭제 실패")
    }
    // Assert
    do {
      let outputPocket = try sut.read()
      XCTAssertTrue(outputPocket.isEmpty)
    } catch {
      XCTFail("읽기 실패")
    }
  }
  
  func test_update() {
    // Arrange
    let items = [
      PocketItemModel(id: .init(), title: "first", memeo: "aa"),
      PocketItemModel(id: .init(), title: "second", memeo: "bb")
    ]
    let pocket = PocketModel(id: .init(), title: "Test", items: items)
    sut.insert(pocket)
    do {
      let pocket = try sut.read().first!
      // Act
      let newItem = PocketItemModel(id: .init(), title: "third", memeo: "cc")
      pocket.items.append(newItem)
      let output = try sut.read().first!.items
      // Assert
      XCTAssertEqual(output, items + [newItem])
    } catch {
      XCTFail("읽기 실패")
    }
  }
  
  func test_multitude_pocket_insert() {
    // Arrange
    let pockets = [
      PocketModel(id: .init(), title: "Test1"),
      PocketModel(id: .init(), title: "Test2"),
      PocketModel(id: .init(), title: "Test3"),
      PocketModel(id: .init(), title: "Test4"),
      PocketModel(id: .init(), title: "Test5"),
      PocketModel(id: .init(), title: "Test6")
    ]
    // Act
    pockets.forEach { pocket in
      sut.insert(pocket)
    }
    // Assert
    do {
      let outputPocket = try sut.read()
      XCTAssertEqual(outputPocket, pockets)
    } catch {
      XCTFail("읽기 실패")
    }
  }
}
