//
//  LocalNotiCenter.swift
//  LocalNotiService
//
//  Created by 이시원 on 3/23/25.
//

import UserNotifications

public final class LocalNotiCenter: Sendable {
  public static let shared = LocalNotiCenter()
  
  init() {}
  
  public func isOnAlarm() async -> Bool {
    return await withCheckedContinuation { continuation in
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        continuation.resume(returning: settings.authorizationStatus == .authorized)
      }
    }
  }
  
  @discardableResult
  public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
    return try await withCheckedThrowingContinuation { continuation in
      UNUserNotificationCenter.current().requestAuthorization(options: options) { isSuceess, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: isSuceess)
        }
      }
    }
  }
  
  public func register(
    title: String,
    body: String,
    id: String,
    trigerType: TrigerType,
    time: Date
  ) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.userInfo = ["id": id]
    trigerType.makeRequsts(time: time, id: id, content: content).forEach {
      UNUserNotificationCenter.current().add($0)
    }
  }
  
  public func remove(id: String, type: TrigerType) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: type.requsetIds(id: id))
  }
  
  public func removeAll() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  public func removeAlert(id: String, type: TrigerType) {
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: type.requsetIds(id: id))
  }
}


