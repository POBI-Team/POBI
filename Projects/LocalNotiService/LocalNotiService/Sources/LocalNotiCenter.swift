//
//  LocalNotiCenter.swift
//  LocalNotiService
//
//  Created by 이시원 on 3/23/25.
//

import UserNotifications

import LocalNotiInterface

public final class LocalNotiCenter: Notifiable {
  public static let shared = LocalNotiCenter()
  private let dateComponentsMaker: DateComponentsMaker = DateComponentsMaker()
  public init() {}
  
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
    dateComponentsMaker.make(type: trigerType, time: time).forEach { dateComponents in
      let isRepeat: Bool
      switch trigerType {
      case .day, .week:
        isRepeat = true
      case .date:
        isRepeat = false
      }
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeat)
      UNUserNotificationCenter.current().add(
        UNNotificationRequest(identifier: id+"-\(dateComponents.description)", content: content, trigger: trigger)
      )
    }
  }
  
  public func remove(id: String, type: TrigerType, time: Date) {
    let ids = dateComponentsMaker.make(type: type, time: time).map { dateComponents in  id+"-\(dateComponents.description)" }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
  }
  
  public func removeAll() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
