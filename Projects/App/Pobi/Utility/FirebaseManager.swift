//
//  FirebaseManager.swift
//  Pobi
//
//  Created by 이시원 on 4/8/25.
//

import Foundation

import FirebaseCore
import FirebaseAnalytics

final class FirebaseManager: NSObject, @unchecked Sendable {
  public enum EventType: String {
    case didTapPocketHidden = "did_tap_pocket_hidden"
    case didTapPocketShown = "did_tap_pocket_Shown"
    case addRecommendedList = "add_recommended_list"
    case alarmActivation = "alarm_activation"
    case alarmDisable = "alarm_disable"

  }
  
  static let shared = FirebaseManager()

  func initSDK() {
    FirebaseApp.configure()
  }

  func setUser(id: String) {
    Analytics.setUserID(id)
  }

  func logEvent(event: EventType, parameters: [String: Any]? = nil) {
    Analytics.logEvent(event.rawValue, parameters: parameters)
  }
}
