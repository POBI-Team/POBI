//
//  LocalNotiInterface.swift
//  LocalNotiInterface
//
//  Created by 이시원 on 7/9/25.
//

import Foundation
import UserNotifications

public protocol Notifiable: Sendable {
  func isOnAlarm() async -> Bool
  func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
  func register(title: String, body: String, id: String, trigerType: TrigerType, time: Date)
  func remove(id: String, type: TrigerType)
  func removeAll()
}
