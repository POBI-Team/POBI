//
//  PobiApp.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import UIKit
import SwiftUI

import PBDesignSystem
import PBStorageInterface
import PBCalender

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

class NotificationManager: ObservableObject {
  @Published var seletedPocketID: UUID?
  
  func handleNotificationTap(id: UUID?) {
    seletedPocketID = id
  }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  var notificationManager = NotificationManager()
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    FirebaseManager.shared.initSDK()
    return true
  }
  
//  앱이 포그라운드에 있을 때 알림 표시
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    completionHandler([.banner, .sound])
//  }
  
  nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    defer {
      completionHandler()
    }
    guard let id = response.notification.request.content.userInfo["id"] as? String else { return }
    DispatchQueue.main.async {
      self.notificationManager.handleNotificationTap(id: UUID(uuidString: id))
    }
  }
}

@main
struct PobiApp: App {
  @StateObject var notificationManager = NotificationManager()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    PBFonts.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      SplashView()
        .environmentObject(appDelegate.notificationManager)
        .environmentObject(PBFormatter())
        .environmentObject(PBCalender())
        .modelContainer(for: [PocketModel.self, PocketItemModel.self, PocketAlarmModel.self])
    }
  }
}
