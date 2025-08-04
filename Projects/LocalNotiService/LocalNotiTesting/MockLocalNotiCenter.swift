//
//  MockLocalNotiCenter.swift
//  LocalNotiTesting
//
//  Created by 이시원 on 7/9/25.
//

import UserNotifications

import LocalNotiInterface

public final class MockLocalNotiCenter: Notifiable, @unchecked Sendable {
  public struct CallCount {
    public var isOnAlarm: Int = 0
    public var requestAuthorization: Int = 0
    public var register: Int = 0
    public var remove: Int = 0
    public var removeAll: Int = 0
  }
  
  public struct ReturnValue {
    public var isOnAlarm: Bool = false
    public var requestAuthorization: Bool = false
  }
  
  public struct InputValue {
    public var requestAuthorization: UNAuthorizationOptions?
    public var register: (title: String, body: String, id: String, trigerType: RepeatType, time: Date)?
    public var remove: (id: String, type: LocalNotiInterface.RepeatType, time: Date)?
  }
  
  public var callCount: CallCount = .init()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()
  
  public init() {}
  
  public func isOnAlarm() async -> Bool {
    callCount.isOnAlarm += 1
    return returnValue.isOnAlarm
  }
  
  public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
    callCount.requestAuthorization += 1
    inputValue.requestAuthorization = options
    return returnValue.requestAuthorization
  }
  
  public func register(title: String, body: String, id: String, trigerType: RepeatType, time: Date) {
    callCount.register += 1
    inputValue.register = (title, body, id, trigerType, time)
  }
  
  public func remove(id: String, type: LocalNotiInterface.RepeatType, time: Date) {
    callCount.remove += 1
    inputValue.remove = (id, type, time)
  }
  
  public func removeAll() {
    callCount.removeAll += 1
  }
}
