//
//  PobiTests.swift
//  PobiTests
//
//  Created by 이시원 on 7/8/25.
//

import XCTest
@testable import Pobi

import PBStorageInterface
import PBStorageTesting
import LocalNotiTesting

import ComposableArchitecture

final class CreatePocketFeatureTests: XCTestCase {
  var sut: TestStore<CreatePocketFeature.State, CreatePocketFeature.Action>!
  var mockStorage: MockProfileStorage!
  var mockLocalNoti: MockLocalNotiCenter!
  var mockFirebaseManager: MockFirebaseManager!
  
  override func setUpWithError() throws {
    mockStorage = MockProfileStorage()
    mockLocalNoti = MockLocalNotiCenter()
    mockFirebaseManager = MockFirebaseManager()
    sut = TestStore(initialState: CreatePocketFeature.State(pocket: nil)) {
      CreatePocketFeature()
    } withDependencies: {
      $0.profileStorage = mockStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
    }
  }
  
  override func tearDownWithError() throws {
    mockStorage = nil
    mockLocalNoti = nil
    mockFirebaseManager = nil
    sut = nil
  }
  
  @MainActor func test_edit_호출_시_onAlarm이_true이면_기존_등록된_알림은_삭제되고_유저_닉네임과_변경된_포켓_제목으로_새로운_알림이_등록된다() async {
    // Arrange
    let pocket = PocketModel(title: "Test", onAlarm: true)
    sut = TestStore(initialState: CreatePocketFeature.State(pocket: pocket)) {
      CreatePocketFeature()
    } withDependencies: {
      $0.profileStorage = mockStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
    }
    mockStorage.returnValue.loadNickname = "testUser"
    
    // Act
    await sut.send(.titleChanged("newTitle")) {
      $0.pocket.title = "newTitle"
    }
    await sut.send(.edit)
    // Assert
    XCTAssertEqual("newTitle", sut.state.pocketModel?.title)
    
    XCTAssertEqual(1, mockStorage.callCount.loadNickname)
    
    XCTAssertEqual(1, mockLocalNoti.callCount.remove)
    XCTAssertEqual(pocket.id.uuidString, mockLocalNoti.inputValue.remove?.id)
    XCTAssertEqual(pocket.pushType, mockLocalNoti.inputValue.remove?.type)

    XCTAssertEqual(1, mockLocalNoti.callCount.register)
    XCTAssertEqual("똑똑! testUser님 'newTitle' 소지품 챙기세요!", mockLocalNoti.inputValue.register?.body)
    XCTAssertEqual(pocket.id.uuidString, mockLocalNoti.inputValue.register?.id)
    XCTAssertEqual(pocket.pushType, mockLocalNoti.inputValue.register?.trigerType)
    XCTAssertEqual(pocket.alarm.time, mockLocalNoti.inputValue.register?.time)
  }
  
  @MainActor func test_edit_호출_시_onAlarm이_false이면_변경_사항이_영구적으로_저장되고_기존_등록된_알림_삭제() async {
    // Arrange
    let pocket = PocketModel(title: "Test", onAlarm: false)
    sut = TestStore(initialState: CreatePocketFeature.State(pocket: pocket)) {
      CreatePocketFeature()
    } withDependencies: {
      $0.profileStorage = mockStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
    }
    mockStorage.returnValue.loadNickname = "testUser"
    
    // Act
    await sut.send(.titleChanged("newTitle")) {
      $0.pocket.title = "newTitle"
    }
    await sut.send(.edit)
    // Assert
    XCTAssertEqual("newTitle", sut.state.pocketModel?.title)
    
    XCTAssertEqual(0, mockStorage.callCount.loadNickname)
    
    XCTAssertEqual(1, mockLocalNoti.callCount.remove)
    XCTAssertEqual(pocket.id.uuidString, mockLocalNoti.inputValue.remove?.id)
    XCTAssertEqual(pocket.pushType, mockLocalNoti.inputValue.remove?.type)

    XCTAssertEqual(0, mockLocalNoti.callCount.register)
  }
}
