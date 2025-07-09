//
//  FirebaseManager.swift
//  Pobi
//
//  Created by 이시원 on 4/8/25.
//

import Foundation

import FirebaseCore
import FirebaseAnalytics

protocol FirebaseManagerInterface: Sendable {
  func logEvent(event: EventType)
  func logEvent(event: EventType, parameters: [String: Any])
}

enum EventType: String {
  case createPocket = "create_pocket"
  case createTemplate = "create_template"
  case addRecommendedList = "add_recommended_list"
  case alarmActivation = "alarm_activation"
  case alarmDisable = "alarm_disable"
  case didTapReset = "did_tap_reset"
  case onCalendar = "on_calendar"
  case offCalendar = "off_calendar"
  case importTemplate = "import_template"
}

final class FirebaseManager: NSObject, FirebaseManagerInterface, @unchecked Sendable {
  static let shared = FirebaseManager()

  func initSDK() {
    FirebaseApp.configure()
  }

  func setUser(id: String) {
    Analytics.setUserID(id)
  }
  
  func logEvent(event: EventType) {
    log(event: event)
  }
  
  func logEvent(event: EventType, parameters: [String : Any]) {
    log(event: event, parameters: parameters)
  }
  
  private func log(event: EventType, parameters: [String: Any]? = nil) {
    Analytics.logEvent(event.rawValue, parameters: parameters)
  }
}
