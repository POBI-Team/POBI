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

@MainActor
final class CreatePocketFeatureTests: XCTestCase {
  var sut: TestStore<CreatePocketFeature.State, CreatePocketFeature.Action>!
  var mockProfileStorage: MockProfileStorage!
  var mockLocalNoti: MockLocalNotiCenter!
  var mockFirebaseManager: MockFirebaseManager!
  var mockPocketStorage: MockPocketStorage!
  
  override func setUp() async throws {
    mockProfileStorage = MockProfileStorage()
    mockLocalNoti = MockLocalNotiCenter()
    mockFirebaseManager = MockFirebaseManager()
    mockPocketStorage = MockPocketStorage()
    sut = TestStore(initialState: CreatePocketFeature.State(pocket: nil)) {
      CreatePocketFeature()
    } withDependencies: {
      $0.profileStorage = mockProfileStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
      $0.pocketStorage = mockPocketStorage
    }
  }
  
  override func tearDown() async throws {
    mockProfileStorage = nil
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
      $0.profileStorage = mockProfileStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
    }
    mockProfileStorage.returnValue.loadNickname = "testUser"
    let pushType = pocket.pushType

    // Act
    await sut.send(.setTitle("newTitle")) {
      $0.pocket.title = "newTitle"
    }
    await sut.send(.edit)
    // Assert
    XCTAssertEqual("newTitle", sut.state.pocketModel?.title)
    
    XCTAssertEqual(1, mockProfileStorage.callCount.loadNickname)
    
    XCTAssertEqual(1, mockLocalNoti.callCount.remove)
    XCTAssertEqual(pocket.id.uuidString, mockLocalNoti.inputValue.remove?.id)
    XCTAssertEqual(pushType, mockLocalNoti.inputValue.remove?.type)

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
      $0.profileStorage = mockProfileStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
    }
    mockProfileStorage.returnValue.loadNickname = "testUser"
    let pushType = pocket.pushType
    // Act
    await sut.send(.setTitle("newTitle")) {
      $0.pocket.title = "newTitle"
    }
    await sut.send(.edit)
    // Assert
    XCTAssertEqual("newTitle", sut.state.pocketModel?.title)
    
    XCTAssertEqual(0, mockProfileStorage.callCount.loadNickname)
    
    XCTAssertEqual(1, mockLocalNoti.callCount.remove)
    XCTAssertEqual(pocket.id.uuidString, mockLocalNoti.inputValue.remove?.id)
    XCTAssertEqual(pushType, mockLocalNoti.inputValue.remove?.type)

    XCTAssertEqual(0, mockLocalNoti.callCount.register)
  }
  
  @MainActor func test_create_호출_시_onAlarm이_true이면_알림_등록_및_영구_저장소에_저장() async {
    // Arrange
    mockProfileStorage.returnValue.loadNickname = "testUser"

    await sut.send(.setOnAlarm(true)) {
      $0.pocket.onAlarm = true
    }
    await sut.send(.setTitle("Test")) {
      $0.pocket.title = "Test"
    }
    
    // Act
    await sut.send(.create)
    // Assert    
    XCTAssertEqual(1, mockProfileStorage.callCount.loadNickname)

    XCTAssertEqual(1, mockLocalNoti.callCount.register)
    XCTAssertEqual("똑똑! testUser님 'Test' 소지품 챙기세요!", mockLocalNoti.inputValue.register?.body)
    
    XCTAssertEqual(1, mockPocketStorage.callCount.insert)
    XCTAssertEqual("Test", mockPocketStorage.inputValue.insert?.title)
  }
  
  @MainActor func test_create_호출_시_onAlarm이_false이면_알림_등록X_영구_저장소에_저장() async {
    // Arrange
    await sut.send(.setTitle("Test")) {
      $0.pocket.title = "Test"
    }
    // Act
    await sut.send(.create)
    // Assert
    XCTAssertEqual(0, mockProfileStorage.callCount.loadNickname)

    XCTAssertEqual(0, mockLocalNoti.callCount.register)
    
    XCTAssertEqual(1, mockPocketStorage.callCount.insert)
    XCTAssertEqual("Test", mockPocketStorage.inputValue.insert?.title)
  }
  
  @MainActor func test_create_호출_시_selectedTemplate이_존재하면_Template을_통해_Pocket_생성() async {
    // Arrange
    let template = TemplateModel(title: "TestTemplate", icon: "✈️")
    await sut.send(.setTemplate(template)) {
      $0.selectedTemplate = template
    }
    await sut.receive(\.setTitle) {
      $0.pocket.title = "TestTemplate"
    }
    await sut.receive(\.setIcon) {
      $0.pocket.icon = "✈️"
    }
    // Act
    await sut.send(.create)
    // Assert
    XCTAssertEqual(1, mockPocketStorage.callCount.insert)
    XCTAssertEqual("TestTemplate", mockPocketStorage.inputValue.insert?.title)
  }
  
  @MainActor func test_switchedAlarm_호출하여_알림을_켤_때_앱_알림이_꺼져있는_경우_isPresentedOffAlarmAlert_true() async {
    // Arrange
    mockLocalNoti.returnValue.isOnAlarm = false
    // Act
    await sut.send(.switchedAlarm(true))
    // Assert
    await sut.receive(\.setIsPresentedOffAlarmAlert) {
      $0.isPresentedOffAlarmAlert = true
    }
    XCTAssertEqual(1, mockLocalNoti.callCount.isOnAlarm)
  }
  
  @MainActor func test_switchedAlarm_호출하여_알림을_켤_때_앱_알림이_켜져있는_경우_onAlarm_true() async {
    // Arrange
    mockLocalNoti.returnValue.isOnAlarm = true
    // Act
    await sut.send(.switchedAlarm(true))
    // Assert
    await sut.receive(\.setOnAlarm) {
      $0.pocket.onAlarm = true
    }
    XCTAssertEqual(1, mockLocalNoti.callCount.isOnAlarm)
  }
  
  @MainActor func test_switchedAlarm_호출하여_알림을_끌_때_앱_알림이_켜져있는_경우_onAlarm_false() async {
    // Arrange
    let pocket = PocketModel(title: "Test", onAlarm: true)
    sut = TestStore(initialState: CreatePocketFeature.State(pocket: pocket)) {
      CreatePocketFeature()
    } withDependencies: {
      $0.profileStorage = mockProfileStorage
      $0.localNotiCenter = mockLocalNoti
      $0.firebaseManager = mockFirebaseManager
    }
    // Act
    await sut.send(.switchedAlarm(false))
    // Assert
    await sut.receive(\.setOnAlarm) {
      $0.pocket.onAlarm = false
    }
    XCTAssertEqual(0, mockLocalNoti.callCount.isOnAlarm)
  }
}
